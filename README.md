# Tomata 🍅

A very simple Pomodoro timer plugin for Neovim.

## Features

- Start a Pomodoro timer with `:Tomata`
- Stop the timer with `:Tomata!`
- Configurable Pomodoro and break durations

## Installation

Using your favorite plugin manager:

```lua
-- Using packer.nvim
use 'sauloperez/tomata.nvim'

-- Using lazy.nvim
{
    'sauloperez/tomata.nvim',
    config = function()
        require('tomata').setup()
    end
}
```

## Usage

- `:Tomata` - Start a Pomodoro timer
- `:Tomata!` - Stop the current timer

## Configuration

You can configure the plugin by passing options to the `setup` function. Both Pomodoro and break durations can be set:

```lua
require('tomata').setup({
    duration = 30, -- Set Pomodoro duration to 30 minutes
    break_duration = 10, -- Set break duration to 10 minutes
})
```
