public class RandomHelper{
    private static Random _random = new Random();
    public static int GetRandomNumber(int min, int max)
    {
        return _random.Next(min, max);
    }

    
}