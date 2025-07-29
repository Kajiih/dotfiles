def --wrapped ocr_directory [...tess_args: string] {
    mkdir text_output | ignore

    glob "*.{jpg,png}" | each {|path|
        let stem = ($path | path parse | get stem)
        let txt_path = $"text_output/($stem)"
        print $"Running OCR on: ($path | path basename)"
        tesseract $path $txt_path ...$tess_args | ignore
    }
}
