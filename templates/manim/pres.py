from manim import *
from manim_slides import Slide

class Pres(Slide):
    def construct(self):
        welcome = Text("Welcome to the presentation!")
        self.play(Write(welcome))
        self.next_slide()
        self.play(FadeOut(welcome))
