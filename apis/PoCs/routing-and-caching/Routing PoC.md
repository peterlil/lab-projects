# Routing PoC

## PoC 1

Select cluster and change URL from a user friendly to backend format

### Populate the cache
Since APIM policies uses some kind of own format when caching, we need to use the `store-cache-value` policy to populate the cache. For this we created a mock API with a policy that stores a key/value combo via a policy.
This mock API is then called once for each value we want to cache in a shell script.

Below is a request to store a value in the cache. 
```http
GET https://plapim.azure-api.net/cache/storevalue?key=se_sv-jackets&value=eov1jnmela5w52m;/clothes/jackets HTTP/1.1
Host: plapim.azure-api.net
```
It will store the key `se_sv-jackets` with the value `eov1jnmela5w52m;/clothes/jackets`. 

Below is the policy used:
```xml
<policies>
	<!-- Throttle, authorize, validate, cache, or transform the requests -->
	<inbound>
		<base />
        <!-- In this APIM policy, read the url parameter value from the request and store it in a variable -->
        <set-variable name="urlParamValue" value="@(context.Request.Url.Query.GetValueOrDefault("value"))" />
        <!-- In this APIM policy, read the url parameter key from the request and store it in a variable -->
        <set-variable name="urlParamKey" value="@(context.Request.Url.Query.GetValueOrDefault("key"))" />
        <!-- In this APIM policy, store the key/value to the external cache -->
        <cache-store-value key="@((string)context.Variables["urlParamKey"])" 
            value="@((string)context.Variables["urlParamValue"])" 
            duration="100000" caching-type="external" />

		<mock-response status-code="200" content-type="application/json" />
	</inbound>
	<!-- Control if and how the requests are forwarded to services  -->
	<backend>
		<base />
	</backend>
	<!-- Customize the responses -->
	<outbound>
		<base />
	</outbound>
	<!-- Handle exceptions and customize error responses  -->
	<on-error>
		<base />
	</on-error>
</policies>
```

#### Sample script to populate the cache

```sh
curl -X GET "https://plapim.azure-api.net/cache/storevalue?key=sv_se-jackets&value=eov1jnmela5w52m;/clothes/jackets"
curl -X GET "https://plapim.azure-api.net/cache/storevalue?key=en_us-jackets&value=eohgawe5a682mt6;/clothes/jackets"
```

### Route the request
Now that we got the key/value-pair above in the cache, we will use it to solve the routing of this frontend request:

```http
GET https://plapim.azure-api.net/garments/jackets HTTP/1.1
Host: plapim.azure-api.net
locale: sv_se
```

so it will become this backend request:

```http
GET https://eov1jnmela5w52m.m.pipedream.net/clothes/jackets?locale=sv_se HTTP/1.1
```

This means that we will use the `locale` header value (`sv_se`), together with the api path `jackets`, to construct the cache key `sv_se-jackets`. The key will then be used to retrieve the cached value (`eov1jnmela5w52m;/clothes/jackets`). The value contains two parts, separated by a semicolon. The first part is a part of the FQDN of the backend service, and the second part is the the backend's api path. Finally, the locale from the header will be appended as query.

Below is the policy to achieve this:
```xml
<policies>
	<inbound>
		<base />
		<!-- Read the header locale from the request into the variable locale -->
		<set-variable name="locale" value="@(context.Request.Headers.GetValueOrDefault("locale"))" />
		<!-- Get the api path part of the path in Url into the variable api-path -->
		<set-variable name="api-path" value="@(context.Request.Url.Path)" />
		<!-- Read the cached path with cache-lookup-value and construct the key like "locale-api-path" -->
		<cache-lookup-value key="@($"{context.Variables["locale"]}-{context.Variables["api-path"]}")" variable-name="cached-value" default-value="null" caching-type="external" />
		<set-variable name="cached-qdn" value="@(((string)context.Variables["cached-value"]).Split(';')[0])" />
		<set-variable name="cached-path" value="@(((string)context.Variables["cached-value"]).Split(';')[1])" />
		<set-backend-service base-url="@($"https://{context.Variables["cached-qdn"]}.m.pipedream.net")" />
		<rewrite-uri template="@((string)context.Variables["cached-path"])" />
		<set-query-parameter name="locale" exists-action="override">
			<value>@((string)context.Variables["locale"])</value>
		</set-query-parameter>
		<!--<mock-response status-code="200" content-type="application/json" />-->
		<return-response>
			<set-status code="200" reason="OK" />
			<set-header name="Content-Type" exists-action="override">
				<value>application/json</value>
			</set-header>
			<set-body>
            @{
                string body = "{\"value\": \"" + (string)context.Request.Url.ToString() + "\"}";
                return body;
            }
            </set-body>
		</return-response>
	</inbound>
	<backend>
		<base />
	</backend>
	<outbound>
		<base />
	</outbound>
	<on-error>
		<base />
	</on-error>
</policies>
```


### Test the caching and routing


```http
GET https://plapim.azure-api.net/garments/jackets HTTP/1.1
Host: plapim.azure-api.net
locale: sv_se
```

```http
GET https://plapim.azure-api.net/garments/jackets HTTP/1.1
Host: plapim.azure-api.net
locale: en_us
```

## PoC 2

Select cluster and use locale and suffix as cluster key to forward to a new FQDN with the complete path.

### Populate the cache

#### Sample script to populate the cache

```sh
curl -X GET "https://plapim.azure-api.net/cache/storevalue?key=sv_se&value=eov1jnmela5w52m"
curl -X GET "https://plapim.azure-api.net/cache/storevalue?key=en_us&value=eohgawe5a682mt6"
```

### Route the request
Now that we got the key/value-pair above in the cache, we will use it to solve the routing of this frontend request:

```http
GET https://plapim.azure-api.net/garments/jackets HTTP/1.1
Host: plapim.azure-api.net
locale: sv_se
```

so it will become this backend request:

```http
GET https://eov1jnmela5w52m.m.pipedream.net/garments/jackets?locale=sv_se HTTP/1.1
```

This means that we will use the `locale` header value (`sv_se`) as the cache key. The key will then be used to retrieve the cached value (`eov1jnmela5w52m`), which is the part of the FQDN. For the backend's api path we will use the path sent in. Finally, the locale from the header will be appended as query.


Below is the policy to achieve this:
```xml
<policies>
	<inbound>
		<base />
		<!-- Read the header locale from the request into the variable locale -->
		<set-variable name="locale" value="@(context.Request.Headers.GetValueOrDefault("locale"))" />
		<!-- Read the cached value for the QDN -->
		<cache-lookup-value key="@((string)context.Variables["locale"])" variable-name="cached-qdn" default-value="null" caching-type="external" />
		<set-variable name="original-suffix" value="@(context.Request.OriginalUrl.Path.Split('/')[1])" />
		<set-variable name="original-path" value="@(context.Request.OriginalUrl.Path)" />
		<set-backend-service base-url="@($"https://{context.Variables["cached-qdn"]}.m.pipedream.net")" />
		<rewrite-uri template="@((string)context.Variables["original-path"])" />
		<set-query-parameter name="locale" exists-action="override">
			<value>@((string)context.Variables["locale"])</value>
		</set-query-parameter>
		<!--<mock-response status-code="200" content-type="application/json" />-->
		<return-response>
			<set-status code="200" reason="OK" />
			<set-header name="Content-Type" exists-action="override">
				<value>application/json</value>
			</set-header>
			<set-body>@{
                string body = "{\"value\": \"" + (string)context.Request.Url.ToString() + "\"}";
                return body;
            }</set-body>
		</return-response>
	</inbound>
	<backend>
		<base />
	</backend>
	<outbound>
		<base />
	</outbound>
	<on-error>
		<base />
	</on-error>
</policies>
```

### Test the caching and routing


```http
GET https://plapim.azure-api.net/garments/jackets2 HTTP/1.1
Host: plapim.azure-api.net
locale: sv_se
```

```http
GET https://plapim.azure-api.net/garments/jackets2 HTTP/1.1
Host: plapim.azure-api.net
locale: en_us
```


Ta bara suffix för uppslag
Appenda allt efteråt + locale


