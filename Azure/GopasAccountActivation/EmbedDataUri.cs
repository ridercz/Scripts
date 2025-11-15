using System;
using System.IO;
using System.Text.RegularExpressions;

var SourceFileName = "activate.md.html";
var TargetFileName = "activate.html";

// Read the HTML file
var html = File.ReadAllText(SourceFileName);

// Regex to find all IMG tags without data URIs
var imgTagRegex = new Regex("<img[^>]+src=[\"'](?!data:)([^\"']+)[\"'][^>]*>", RegexOptions.IgnoreCase);
var matches = imgTagRegex.Matches(html);

foreach (Match match in matches)
{
    var imgTag = match.Value;
    var imgSrc = match.Groups[1].Value;

    // Read the image file
    if (File.Exists(imgSrc))
    {
        var imgSrcNoQuery = imgSrc.Split(new[] { '?', '#' })[0];
        var imgExtension = Path.GetExtension(imgSrcNoQuery).TrimStart('.').ToLowerInvariant();
        var imgBytes = File.ReadAllBytes(imgSrcNoQuery);
        var base64Img = Convert.ToBase64String(imgBytes);
        string dataUri;

        if (imgExtension == "svg")
        {
            // For SVG, use URL-encoding (human-readable, avoids extra base64 bloat)
            var svgText = File.ReadAllText(imgSrcNoQuery);
            var encodedSvg = Uri.EscapeDataString(svgText);
            dataUri = $"data:image/svg+xml;utf8,{encodedSvg}";
            Console.WriteLine($"Embedded SVG image {imgSrcNoQuery} as URL-encoded data URI.");
        }
        else if (imgExtension == "png" || imgExtension == "jpg" || imgExtension == "jpeg")
        {
            // Use base64 for binary images. Map "jpg" -> "jpeg" MIME type.
            var mime = imgExtension == "jpg" ? "jpeg" : imgExtension;
            dataUri = $"data:image/{mime};base64,{base64Img}";
            Console.WriteLine($"Embedded {mime.ToUpper()} image {imgSrcNoQuery} as base64 data URI.");
        }
        else
        {
            // Ignore other file types
            Console.WriteLine($"Skipping unsupported image type '{imgExtension}' for '{imgSrcNoQuery}'.");
            continue;
        }

        // Replace the src attribute with the data URI
        var newImgTag = imgTagRegex.Replace(imgTag, m => m.Value.Replace(imgSrc, dataUri));
        html = html.Replace(imgTag, newImgTag);
    }
    else
    {
        Console.WriteLine($"Warning: Image file '{imgSrc}' not found.");
    }
}

// Write the modified HTML to a new file
File.WriteAllText(TargetFileName, html);