//
//  GlassWindow.c
//  gamecon
//
//  Created by Ricky Ayoub on 1/12/18.
//

#include "GlassWindow.h"
#include <SDL2/SDL.h>

void GlassWindow_init(GlassWindow* self)
{
    if (SDL_Init(SDL_INIT_EVERYTHING) != 0){
        printf("[FATAL] SDL initialization failed!");
        return;
    }
    
    // Create SDL window
//    self->window = SDL_CreateWindow("GlassCon", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WIDTH, HEIGHT, 0);
//    self->renderer = SDL_CreateRenderer(self->window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_TARGETTEXTURE);

}
