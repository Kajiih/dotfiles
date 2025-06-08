module completions {

  def "nu-complete btm default_widget_type" [] {
    [ "cpu" "mem" "net" "network" "proc" "process" "processes" "temp" "temperature" "disk" "batt" "battery" ]
  }

  def "nu-complete btm default_cpu_entry" [] {
    [ "all" "avg" ]
  }

  def "nu-complete btm memory_legend" [] {
    [ "none" "top-left" "top" "top-right" "left" "right" "bottom-left" "bottom" "bottom-right" ]
  }

  def "nu-complete btm network_legend" [] {
    [ "none" "top-left" "top" "top-right" "left" "right" "bottom-left" "bottom" "bottom-right" ]
  }

  def "nu-complete btm theme" [] {
    [ "default" "default-light" "gruvbox" "gruvbox-light" "nord" "nord-light" ]
  }

  # A customizable cross-platform graphical process/system monitor for the terminal. Supports Linux, macOS, and Windows.
  export extern btm [
    --autohide_time           # Temporarily shows the time scale in graphs.
    --basic(-b)               # Hides graphs and uses a more basic look.
    --config_location(-C): string # Sets the location of the config file.
    --default_time_value(-t): string # Default time value for graphs.
    --default_widget_count: string # Sets the N'th selected widget type as the default.
    --default_widget_type: string@"nu-complete btm default_widget_type" # Sets the default widget type. Use --help for more info.
    --disable_click           # Disables mouse clicks.
    --dot_marker(-m)          # Uses a dot marker for graphs.
    --expanded(-e)            # Expand the default widget upon starting the app.
    --hide_table_gap          # Hides spacing between table headers and entries.
    --hide_time               # Hides the time scale from being shown.
    --rate(-r): string        # Sets how often data is refreshed.
    --retention: string       # How far back data will be stored up to.
    --show_table_scroll_position # Shows the list scroll position tracker in the widget title for table widgets.
    --time_delta(-d): string  # The amount of time changed upon zooming.
    --case_sensitive(-S)      # Enables case sensitivity by default.
    --current_usage(-u)       # Calculates process CPU usage as a percentage of current usage rather than total usage.
    --disable_advanced_kill   # Hides additional stopping options Unix-like systems.
    --group_processes(-g)     # Groups processes with the same name by default.
    --process_memory_as_value # Defaults to showing process memory usage by value.
    --process_command         # Shows the full command name instead of the process name by default.
    --regex(-R)               # Enables regex by default while searching.
    --tree(-T)                # Makes the process widget use tree mode by default.
    --unnormalized_cpu(-n)    # Show process CPU% usage without averaging over the number of CPU cores.
    --whole_word(-W)          # Enables whole-word matching by default while searching.
    --celsius(-c)             # Use Celsius as the temperature unit. Default.
    --fahrenheit(-f)          # Use Fahrenheit as the temperature unit.
    --kelvin(-k)              # Use Kelvin as the temperature unit.
    --cpu_left_legend(-l)     # Puts the CPU chart legend on the left side.
    --default_cpu_entry: string@"nu-complete btm default_cpu_entry" # Sets which CPU entry type is selected by default.
    --hide_avg_cpu(-a)        # Hides the average CPU usage entry.
    --memory_legend: string@"nu-complete btm memory_legend" # Where to place the legend for the memory chart widget.
    --enable_cache_memory     # Enables collecting and displaying cache and buffer memory.
    --network_legend: string@"nu-complete btm network_legend" # Where to place the legend for the network chart widget.
    --network_use_bytes       # Displays the network widget using bytes.
    --network_use_binary_prefix # Displays the network widget with binary prefixes.
    --network_use_log         # Displays the network widget with a log scale.
    --use_old_network_legend  # (DEPRECATED) Uses a separate network legend.
    --battery                 # Shows the battery widget in non-custom layouts.
    --enable_gpu              # Enable collecting and displaying GPU usage.
    --theme: string@"nu-complete btm theme" # Use a built-in color theme, use '--help' for info on the colors. [possible values: default, default-light, gruvbox, gruvbox-light, nord, nord-light]
    --help(-h)                # Prints help info (for more details use '--help'.
    --version(-V)             # Prints version information.
  ]

}

export use completions *
