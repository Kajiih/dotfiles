# Load secrets from Bitwarden Secrets into environment variables
export def --env load-secrets [
    access_token: string # Bitwarden access token (required)
]: nothing -> record<type: string> {
    # Validate access token
    if ($access_token | is-empty) {
        error make {msg: "Access token is required"}
    }

    # Retrieve secrets
    let secrets = (
        try {
            bws --access-token $access_token secret list --output json | from json
        } catch {|err|
            error make {msg: $"❌ Failed to retrieve secrets: ($err.msg)"}
        }
    )

    # Create record for load-env
    let secret_record = (
        $secrets | reduce -f {} {|it, acc|
            $acc | insert $it.key $it.value
        }
    )

    # Load into environment
    load-env $secret_record
    print (ansi g) $"🎉 Loaded ($secrets | length) secrets from Bitwarden 🎉" (ansi reset)

    $secret_record
}

# Get access token. The method to get the token depends on the OS.
# 
# On MacOS:
#   To add the token: `security add-generic-password -a $env.USER -s bws_token -w <access_token>`
# 
# On Linux:
# TODO
# 
# On Windows:
# TODO
# 
# TODO: Verify implementation on Windows and linux
# TODO: Check if we use a cross platform method instead of different tool for each platform
export def get-token []: nothing -> string {
    let os = $nu.os-info.name
    match $os {
        # Adapted from: https://www.aria.ai/blog/storing-secrets-with-keychain/
        "macos" => {
            ^security find-generic-password -s bws_token -w | str trim
        }
        "linux" => {
            # If libsecret is available
            try {
                ^secret-tool lookup service bws_token | str trim
            } catch {
                # fallback to a file
                open ($nu.data-dir | path join ".bws_token") | str trim
            }
        }
        "windows" => {
            # Replace this with the method you choose to retrieve Windows credential
            open ($nu.data-dir | path join ".bws_token") | str trim
        }
        _ => {
            error make {msg: $"Unsupported OS: ($os)"}
        }
    }
}

# Set BWS_ACCESS_TOKEN env var using get-token and load other secrets using its value.
# Does nothing if BWS_ACCESS_TOKEN is already set.
export def --env load-all []: nothing -> nothing {
    # Check if BWS_ACCESS_TOKEN is already set
    if not ($env | columns | any {|e| $e == 'BWS_ACCESS_TOKEN' }) {
        let token = (
            try {
                get-token
            } catch {|err|
                error make {msg: $"❌ Failed to get Bitwarden Secrets access token: ($err.msg)"}
            }
        )

        $env.BWS_ACCESS_TOKEN = $token

        load-secrets $token
    }
}
