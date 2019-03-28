package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.Arrays;
import java.util.List;

public class Hello implements RequestHandler<String, String>
{
    @Override
    public String handleRequest(String input, Context context)
    {
        return String.format("Hello, %s!", input);
    }

    public String badCommaWhiteSpaceBeforeAndAfter(String input ,String anotherInput)
    {
        return "badCommaWhiteSpaceBeforeAndAfter";
    }

    public void badGenericsWhiteSpace()
    {
        List< String> strings = Arrays.asList("hello", "world");
    }

    public boolean badOperatorWhiteSpace()
    {
        int sum = 1+2;
        return sum==3;
    }

    @SafeVarargs public final void badAnnotations(String... badVarargsAnnotation)
    {
        @SuppressWarnings("default") Hello badSuppressWarningsAnnotation;
    }
}