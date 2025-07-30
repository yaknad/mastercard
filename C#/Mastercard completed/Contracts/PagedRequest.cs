using System.ComponentModel.DataAnnotations;

namespace Contracts;

public class PagedRequest
{
    [Range(1, int.MaxValue, ErrorMessage = "page number must be a positive number")]
    public int PageNumber { get; set; } = 1;
    [Range(1, 100, ErrorMessage = "page size must be between 0 and 100")]
    public int PageSize { get; set; } = 10;
}
