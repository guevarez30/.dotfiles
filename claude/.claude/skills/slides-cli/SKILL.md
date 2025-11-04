---
name: slides-cli
description: Expert guidance for creating terminal-based presentations using the Slides CLI tool. Helps with markdown syntax, code execution, preprocessing, themes, and best practices for developer presentations.
---

# Terminal Slideshows with Slides CLI

## Overview

**Slides** is a terminal-based presentation tool written in Go that allows you to create and present beautiful slideshows directly from the command line using Markdown. It's perfect for developer presentations, live coding demos, and minimalist presentations.

**Repository:** https://github.com/maaslalani/slides

### Key Capabilities

- Create presentations using standard Markdown
- Live file watching and auto-reload during presentations
- Execute code blocks interactively (ctrl+e)
- Pre-process slides with dynamic command output
- Share presentations over SSH
- Fully customizable themes
- Search functionality within presentations
- Supports syntax highlighting for 20+ languages

---

## Installation

### Homebrew (macOS/Linux)

```bash
brew install slides
```

### Arch Linux

```bash
yay -S slides
```

### Snap (Linux)

```bash
sudo snap install slides
```

### Go Install

```bash
go install github.com/maaslalani/slides@latest
```

### From Source

```bash
git clone https://github.com/maaslalani/slides.git
cd slides
go install
```

---

## Basic Slide Syntax

Slides uses standard Markdown with `---` as the slide separator.

### Simple Example

```markdown
# Welcome to My Presentation

## Subtitle here

This is the first slide

---

## Second Slide

- Bullet point 1
- Bullet point 2
- Bullet point 3

---

## Third Slide

Some content here
```

### Running a Presentation

```bash
slides presentation.md
```

The presentation will open in your terminal with full navigation controls.

---

## Markdown Elements Supported

### Headers

```markdown
# H1 Header

## H2 Header

### H3 Header

#### H4 Header

##### H5 Header

###### H6 Header
```

### Lists

**Bulleted:**

```markdown
- Item 1
- Item 2
- Item 3
```

**Numbered:**

```markdown
1. First item
2. Second item
3. Third item
```

### Code Blocks

````markdown
```python
def hello():
    print("Hello, world!")
```
````

### Tables

```markdown
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Data 1   | Data 2   | Data 3   |
| More 1   | More 2   | More 3   |
```

### Emphasis

```markdown
_italic text_
**bold text**
~~strikethrough~~
`inline code`
```

---

## Metadata Configuration

Add metadata at the top of your presentation file using YAML front matter:

```markdown
---
theme: ./path/to/theme.json
author: Your Name
date: MMMM dd, YYYY
paging: Slide %d / %d
---

# First Slide

Content here...
```

### Metadata Options

| Option   | Description                          | Example          |
| -------- | ------------------------------------ | ---------------- |
| `theme`  | Path to theme file (local or remote) | `./mytheme.json` |
| `author` | Author name displayed in footer      | `John Doe`       |
| `date`   | Date shown in footer                 | `May 22, 2024`   |
| `paging` | Page number format                   | `Page %d of %d`  |

### Date Format Tokens

- `YYYY` - Full year (2024)
- `YY` - Two-digit year (24)
- `MMMM` - Full month name (January)
- `MMM` - Abbreviated month (Jan)
- `MM` - Two-digit month (01)
- `DD` - Two-digit day (05)

### Hide Footer

To hide the footer bar entirely:

```markdown
---
author: ""
date: ""
paging: ""
---
```

---

## Code Execution

One of the most powerful features: execute code blocks directly during your presentation!

### How It Works

1. Create a code block with a supported language
2. During presentation, navigate to that slide
3. Press `ctrl+e` to execute the code
4. Output appears as virtual text below the code block

### Supported Languages

- Shell: bash, zsh, fish
- Scripting: python, ruby, perl, javascript
- Compiled: go, rust, java, cpp, swift
- Other: elixir, dart, v, julia, scala

### Example

````markdown
---

## Python Demo

```python
import datetime
print(f"Current time: {datetime.datetime.now()}")
```

Press ctrl+e to execute!
````

### Advanced: Hidden Code Lines

Use `///` to hide verbose imports/boilerplate:

````markdown
```go
/// package main
/// import "fmt"
func main() {
    fmt.Println("Hello from Go!")
}
```
````

The `///` lines won't display but will be included during execution.

### Copy Code

Press `y` to copy the code block to clipboard.

---

## Preprocessing

Pre-process slides to dynamically generate content before the presentation.

### How It Works

1. Use three tildes (`~~~`) instead of backticks
2. Specify a command
3. Make the file executable: `chmod +x presentation.md`
4. The command output replaces the code block

### Example: Import External Files

```markdown
---

## Code Import

```bash
cat examples/hello.py
```
```

The file content will be displayed in place of the command.

### Example: Generate Diagrams

```markdown
---

## Architecture Diagram

```graph-easy
[Frontend] -> [API] -> [Database]
[API] -> [Cache]
```
```

### Example: PlantUML Diagrams

```markdown
---

## Sequence Diagram

```bash
echo '@startuml
Alice -> Bob: Hello
Bob -> Alice: Hi!
@enduml' | plantuml -pipe -tutxt
```
```

### Security Note

Preprocessing requires executable permissions to prevent accidental code execution:

```bash
chmod +x your-presentation.md
```

---

## Keyboard Shortcuts

### Navigation

| Key(s)                                    | Action                                      |
| ----------------------------------------- | ------------------------------------------- |
| `Space`, `→`, `↓`, `Enter`, `n`, `j`, `l` | Next slide                                  |
| `←`, `↑`, `p`, `h`, `k`                   | Previous slide                              |
| `g g`                                     | First slide                                 |
| `G`                                       | Last slide                                  |
| `<number>G`                               | Go to specific slide (e.g., `5G` → slide 5) |

### Other Actions

| Key(s)   | Action                     |
| -------- | -------------------------- |
| `/`      | Search within presentation |
| `ctrl+n` | Next search result         |
| `ctrl+e` | Execute code block         |
| `y`      | Copy code block            |
| `q`      | Quit presentation          |

---

## Theme Customization

Themes are defined in JSON files based on [glamour themes](https://github.com/charmbracelet/glamour/tree/master/styles).

### Using a Theme

```markdown
---
theme: ./mytheme.json
---
```

Or use a remote theme:

```markdown
---
theme: https://example.com/theme.json
---
```

### Theme Structure

```json
{
  "document": {
    "color": "252",
    "block_prefix": "\n",
    "block_suffix": "\n",
    "margin": 2
  },
  "heading": {
    "h1": {
      "color": "39",
      "prefix": "# ",
      "bold": true
    },
    "h2": {
      "color": "170",
      "prefix": "## "
    }
  },
  "code_block": {
    "color": "244",
    "background_color": "236"
  },
  "emph": {
    "italic": true,
    "color": "108"
  },
  "strong": {
    "bold": true,
    "color": "168"
  },
  "list": {
    "color": "252"
  }
}
```

### Theme Elements You Can Customize

- Document: colors, margins, prefixes
- Headings: H1-H6 styles, colors, prefixes
- Text: emphasis (italic), strong (bold), strikethrough
- Code: blocks and inline code styling
- Lists: bullets, enumeration, tasks
- Links: colors and formatting
- Tables: borders and separators
- Block quotes: indentation and styling

---

## Advanced Features

### Live File Watching

While presenting, save changes to your markdown file and the presentation auto-reloads. Perfect for:

- Live editing during demos
- Real-time collaboration
- Iterative content refinement

### SSH Presentations

Share presentations over SSH:

```bash
ssh user@host "slides presentation.md"
```

### Stdin Input

```bash
cat presentation.md | slides
```

### Search Functionality

1. Press `/` during presentation
2. Type search term
3. Press `ctrl+n` to cycle through results

---

## Best Practices

### 1. Keep Slides Simple

- One main idea per slide
- Use plenty of whitespace
- Short bullet points (5-7 words max)

### 2. Leverage Code Execution

- Demo live code instead of screenshots
- Show real-time results
- Build trust with working examples

### 3. Use Preprocessing for Dynamic Content

- Import real code files (always up-to-date)
- Generate diagrams automatically
- Show actual system information

### 4. Structure Your Presentation

```markdown
---
# Title Slide
---

## Agenda

---

## Content Section 1

---

## Demo

---

## Summary

---

## Questions?
```

### 5. Test Before Presenting

- Run through the entire presentation
- Test all code executions (`ctrl+e`)
- Verify preprocessing works (`chmod +x` required)
- Check terminal size (resize if needed)

### 6. Use Clear Transitions

```markdown
---
## Previous Topic
---

## Transition Slide

> Moving on to...

---

## Next Topic
```

---

## Example Templates

### Basic Presentation

````markdown
---
author: Your Name
date: MMMM dd, YYYY
paging: Slide %d / %d
---

# Presentation Title

## Subtitle

Your Name

---

## Agenda

- Introduction
- Main Content
- Demo
- Conclusion

---

## Introduction

Brief overview of what we'll cover

---

## Main Point 1

Content here...

---

## Demo

```python
print("Hello, world!")
```

---

## Conclusion

- Key takeaway 1
- Key takeaway 2
- Key takeaway 3

---

## Thank You!

Questions?
````

### Technical Presentation with Code

````markdown
---
author: Developer Name
date: January 2025
theme: ./tech-theme.json
---

# API Development Workshop

---

## What We'll Build

A RESTful API with:

- User authentication
- CRUD operations
- Real-time data

---

## Setup

```bash
pip install flask flask-jwt
```

---

## Basic Flask App

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return {"message": "Hello, API!"}

if __name__ == '__main__':
    app.run(debug=True)
```

Press ctrl+e to run!

---

## Live Demo

Let's test the API...
````

---

## Tips for Claude Agents

When creating slideshows:

1. **Start with structure**: Create title → agenda → content → conclusion
2. **Use metadata**: Always include author, date, and paging
3. **Leverage code blocks**: Use syntax-appropriate language identifiers
4. **Consider preprocessing**: For diagrams, imports, or dynamic content
5. **Keep it visual**: Use headers, lists, and whitespace effectively
6. **Test interactivity**: Include executable code blocks where relevant
7. **Think about flow**: Each slide should lead naturally to the next
8. **Respect terminal constraints**: Keep lines under 80-100 characters
9. **Use consistent formatting**: Match the style throughout
10. **Remember shortcuts**: Design for keyboard-only navigation

### Common Pitfalls to Avoid

- ❌ Too much text on one slide
- ❌ Forgetting `---` slide separators
- ❌ Using unsupported markdown (HTML usually won't work)
- ❌ Not testing code execution before presenting
- ❌ Forgetting `chmod +x` for preprocessing
- ❌ Making slides too wide for standard terminals

### Quality Checklist

- [ ] Every slide has clear purpose
- [ ] Code blocks have language specified
- [ ] Metadata configured appropriately
- [ ] Tested in actual terminal (not just rendered)
- [ ] Navigation flow makes sense
- [ ] Code execution works (if applicable)
- [ ] Preprocessing tested (if used)
- [ ] Theme looks good (if custom)

---

## Resources

- **GitHub Repository**: https://github.com/maaslalani/slides
- **Glamour Themes**: https://github.com/charmbracelet/glamour/tree/master/styles
- **Example Presentations**: https://github.com/maaslalani/slides/tree/main/examples

---

## Quick Reference

### Create a Presentation

```bash
# Create markdown file
vim presentation.md

# Run it
slides presentation.md

# With live reload
slides --watch presentation.md
```

### Essential Shortcuts

- `Space` → next slide
- `←` → previous slide
- `/` → search
- `ctrl+e` → execute code
- `g g` → first slide
- `G` → last slide
- `q` → quit

### File Structure

```markdown
---
author: Name
date: Date
paging: Slide %d / %d
---

# Title

---

## Content

---

## End
```

Now you're ready to create amazing terminal presentations! 🎯
