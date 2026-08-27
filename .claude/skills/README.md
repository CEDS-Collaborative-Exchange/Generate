# Project Skills

Project-scoped Claude Code skills live here, one subfolder per skill:

```
.claude/skills/
  <skill-name>/
    SKILL.md
```

Each `SKILL.md` needs frontmatter with `name` and `description`, followed by
the instructions Claude should follow when the skill is invoked (via
`/<skill-name>` or automatically when relevant). See
https://docs.claude.com/en/docs/claude-code/skills for the full format.
