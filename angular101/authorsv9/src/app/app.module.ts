import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http' // HTTP_INTERCEPTOR for adding Bearer header
import { AppRoutingModule } from './app-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms'
import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { NavbarComponent } from './navbar/navbar.component';
import { AuthorsComponent } from './authors/authors.component';
import { AuthorDetailsComponent } from './author-details/author-details.component';
import { PageNotFoundComponent } from './page-not-found/page-not-found.component';
import { MsalModule, MsalInterceptor, MSAL_CONFIG, MSAL_CONFIG_ANGULAR, MsalService, MsalAngularConfiguration, MsalGuard, BroadcastService } from '@azure/msal-angular';
import { Configuration } from 'msal';

export const _protectedResourceMap: [string, string[]][] = [
	['https://graph.microsoft.com/v1.0/me', ['User.Read']],
	['https://localhost:44320/api/Authors', ['https://easyauthplapi.azurewebsites.net/user_impersonation']]
]

function MSALConfigFactory(): Configuration {
	return {
		auth: {
			clientId: 'a602f6a2-5875-4e17-a141-802d37c08a06'
			, authority: 'https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47'
			, redirectUri: 'http://localhost:4200'
			, validateAuthority: true
			, postLogoutRedirectUri: 'http://localhost:4200'
			, navigateToLoginRequestUrl: true
		}
	}
}

function MSALAngularConfigFactory(): MsalAngularConfiguration {
	return {
		popUp: false
		, consentScopes: [
			'User.Read'
		], protectedResourceMap: _protectedResourceMap
	}
}

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    NavbarComponent,
    AuthorsComponent,
    AuthorDetailsComponent,
    PageNotFoundComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
	HttpClientModule,
	FormsModule,
	ReactiveFormsModule
  ],
  providers: [
	{
		provide: HTTP_INTERCEPTORS
		, useClass: MsalInterceptor
		, multi: true
	},
	{
		provide: MSAL_CONFIG
		, useFactory: MSALConfigFactory
	},
	{
		provide: MSAL_CONFIG_ANGULAR
		, useFactory: MSALConfigFactory
	}, BroadcastService, MsalService, MsalGuard
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
