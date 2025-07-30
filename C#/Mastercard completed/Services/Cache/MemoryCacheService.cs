using Microsoft.Extensions.Caching.Memory;

namespace Services.Cache;

// TODO: in the future, consider using a distributed cache implementation (like Redis) for scalability
public class MemoryCacheService(IMemoryCache memoryCache) : ICacheService
{
    private readonly IMemoryCache _memoryCache = memoryCache;

    public T? Get<T>(string key)
    {
        return _memoryCache.TryGetValue(key, out T? value) ? value : default;
    }

    public void Set<T>(string key, T value, TimeSpan? absoluteExpiration = null)
    {
        var options = new MemoryCacheEntryOptions();
        if (absoluteExpiration.HasValue)
            options.SetAbsoluteExpiration(absoluteExpiration.Value);

        _memoryCache.Set(key, value, options);
    }

    public void Remove(string key)
    {
        _memoryCache.Remove(key);
    }
}