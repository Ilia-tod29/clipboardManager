# CLIPBOARD MANAGER - VIM PLUGIN

Isn't it annoying when you copy something to lose your previous copy?

This vim plugin works as a clipboard manager that keeps up to 40 records.

Hope you enjoy it :)

## Prerequisite
Have this in your .vimrc(.vim/vimrc) file in order to have the full functionalities:

``set clipboard=unnamed,unnamedplus``

## Usage

When you make several copies of different texts with this plugin you will be able to go backward and forward in your history of copies.

### Mappings

`<Shift + <Right arrow>>` - move forward with step - 1

`<Shift + <Left arrow>>` - move backward with step - 1

`<Ctrl + b> + 3` - move forward with step - 3

`<Ctrl + b> + 5` - move forward with step - 5

`<Ctrl + b> + 9` - move forward with step - 9

### Auto commands

- When you 'Yank' a text it will save it to the clipboard.
- [Works with prerequisite] When you copy something from outside of vim when you get back to vim the last copied text is being added to the clipboard.
- [Keep in mind] When leaving vim the plugin saves your current clipboard to the register 'z'
- [Keep in mind] When entering vim the plugin will try to restore your last clipboard from the register 'z'

### Commands

`:BrowseClipboard <args1>` - browses in the clipboard with a step(<args1>). The direction of browsing is determined based on the step `-` positive step &rarr; forward | negative step &rarr; backward.

`:ShowClipboard` - Shows the number of elements in the clipboard and the numbered elements themselves. Note: Elements are being displayed only until the 150th character.

`:ClearClipboard` - Clears the records in the clipboard