# Create output folder if it doesn't exist
mkdir converted | ignore

# Convert HEIC files
glob "*.heic" | each {|path|
    let stem = ($path | path parse | get stem)
    print $"Converting ($path | path basename)"
    let out_path = $"converted/($stem).jpg"
    magick $path $out_path
}

# Convert PDF files (all pages)
glob "*.pdf" | each {|path|
    let stem = ($path | path parse | get stem)
    print $"Converting ($path | path basename)"
    let out_pattern = $"converted/($stem)-page%d.png"
    magick $path $out_pattern
}
