# PICO8 Side Scroller Template

## Table Of Content

* [Introduction](#introduction)
* [How To Start A Project](#how-to-start-a-project)

## Introduction

This is a simple starting point for a 2D Side Scroller Platformer in PICO8, it includes the following things:

* A simple character
    * Move
        * With a flag to disable movement
    * Jump
        * With Coyote
        * With Jump Buffer
    * Dash
        * Dash is measured in seconds
        * Dash has cooldown
    * Be invincible for a pre-configured amount of time
* A simple pickup that interacts with the player
* A simple spike hazard that interacts with the player
* A playable level as a demo

This is a nice starting point for people that want to have some basic platformer code and focus on more important things like gameplay and game feel.

### NOTE:

Since I don't like the coding style inside of the PICO8 editor with the very small screen and the font being all weird and such (in my opinion) the source code is in `.lua` files inside of `/src` and the only thing that there is in the editor is the includes to the files so that we can work with them.

## How To Start A Project

* Download the project from [the releases page](https://github.com/odinn1984/PICO8-SideScroller-Template/releases)
* Open PICO8 and create a new folder where you keep your projects
* Copy the content of the repository to that folder
* Delete the following files/directories
    * .git
    * .github
    * .gitignore
    * .releaserc.json
    * LICENSE
    * README.md
* Rename `sidescroll-template.p8` to whatever you want to call your project
* Do your thing :)


