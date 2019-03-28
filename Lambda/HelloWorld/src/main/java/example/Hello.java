package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class Hello implements RequestHandler<String, String>
{
    @Override // OK annotation
    public String handleRequest(String input, Context context)
    {
        @SuppressWarnings("default") //OK annotation
        Hello example;

        return String.format("Hello, %s!", input);
    }
}
