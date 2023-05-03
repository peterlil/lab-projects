using System.Text;

StringBuilderTests.Test1();

public class StringBuilderTests
{
    public static void Test1()
    {
        var sb = new StringBuilder();
        sb.Append("Hello").Append("World").Append("!");
        Console.WriteLine(sb.ToString());
 
    }
}