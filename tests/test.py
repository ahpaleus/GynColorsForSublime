#!/usr/bin/env python3
"""Test file for GynColors theme - Python syntax."""

import os
from collections import defaultdict

# Comment: should be bright green (#00ff00)
# TODO: should be dark on amber background

GLOBAL_CONSTANT = 42
PI = 3.14159

class Animal:
    """Base class for animals."""

    def __init__(self, name: str, legs: int = 4):
        self.name = name
        self.legs = legs
        self._internal = None

    def speak(self) -> str:
        raise NotImplementedError

    @staticmethod
    def is_alive():
        return True

    @property
    def description(self):
        return f"Animal: {self.name} with {self.legs} legs"


class Dog(Animal):
    """Inherited class - should be italic magenta."""

    species = "Canis familiaris"

    def speak(self) -> str:
        return "Woof!"

    def fetch(self, item: str) -> bool:
        if item is None:
            return False
        for i in range(10):
            while True:
                break
        return True


def greet(name, greeting="Hello"):
    # String escape sequences: \n \t \\ should be purple on gray
    message = f"{greeting}, {name}!\n"
    raw = r"no \escape \here"
    path = "C:\\Users\\test\ttab"
    print(message)
    return message


# Language constants
values = [True, False, None]
empty = {}
number_int = 42
number_float = 3.14
number_hex = 0xFF
number_oct = 0o77
number_bin = 0b1010
number_complex = 3 + 4j

# Operators
result = (10 + 20) * 3 / 2 - 1
is_equal = result == 42
is_not = not is_equal
combined = is_equal and is_not or True
bitwise = 0xFF & 0x0F | 0xF0 ^ 0x55

# Format specifiers
formatted = "Value: %d, String: %s, Float: %.2f" % (42, "hello", 3.14)

# Comprehensions and keywords
squares = [x ** 2 for x in range(10) if x % 2 == 0]
mapping = {k: v for k, v in enumerate(squares)}

# Exception handling
try:
    result = 1 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
finally:
    pass

# Lambda and functional
transform = lambda x: x * 2
filtered = list(filter(lambda x: x > 5, squares))

# Async (syntax only)
async def fetch_data(url: str) -> dict:
    async with open(url) as f:
        data = await f.read()
    return {"data": data}

# Type hints
from typing import List, Dict, Optional, Union
def process(items: List[int], config: Optional[Dict[str, Union[int, str]]] = None) -> bool:
    assert isinstance(items, list)
    yield from items

if __name__ == "__main__":
    dog = Dog("Rex", legs=4)
    print(dog.speak())
    greet("World")
