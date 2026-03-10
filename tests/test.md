# Heading 1

## Heading 2

### Heading 3

#### Heading 4

Regular paragraph text with **bold text** and *italic text* and ***bold italic***.

Also __bold__ and _italic_ with underscores.

---

## Links and Images

[Inline link](https://example.com)
[Link with title](https://example.com "Example Site")
<https://example.com>
[Reference link][ref1]

![Alt text](image.png)
![Image with title](photo.jpg "A photo")

[ref1]: https://example.com "Reference"

## Lists

### Unordered
- Item one
- Item two
  - Nested item
  - Another nested
    - Deep nested
- Item three

### Ordered
1. First item
2. Second item
   1. Sub-item
   2. Another sub-item
3. Third item

### Task List
- [x] Completed task
- [ ] Pending task
- [ ] Another pending

## Code

Inline `code span` in a sentence.

```python
def hello(name: str) -> str:
    """Fenced code block with syntax."""
    return f"Hello, {name}!"
```

```javascript
const greet = (name) => `Hello, ${name}!`;
```

    Indented code block
    with multiple lines
    no syntax highlighting

## Blockquotes

> Single line quote

> Multi-line quote
> with continuation
>
> > Nested blockquote
> > inside another

## Tables

| Color     | Hex       | Usage       |
|-----------|-----------|-------------|
| Green     | `#00ff00` | Comments    |
| Lavender  | `#B7B7F7` | Keywords    |
| Magenta   | `#ff8bff` | Types       |
| Orange    | `#f0ad6d` | Strings     |
| Purple    | `#c080d0` | Operators   |
| Teal      | `#409090` | Preprocessor|

## Emphasis Combinations

This is *italic*, this is **bold**, this is ***bold italic***.

This is ~~strikethrough~~ text.

## HTML in Markdown

<div class="note">
  <p>HTML block inside markdown</p>
</div>

## Horizontal Rules

---
***
___

## Footnotes

Here is a sentence with a footnote[^1].

[^1]: This is the footnote content.

## Definition List (extended)

Term 1
: Definition for term 1

Term 2
: Definition for term 2
