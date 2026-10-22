# Pi agent definitions

These definitions adapt pstack's agent prompts for pi-subagents. Upstream prompts stay in `agents/`. The translated copies stay here so Git can track both independently.

## Sources

| Definition | Source | Last synchronized source commit |
| --- | --- | --- |
| [poteto-agent.md](poteto-agent.md) | [agents/poteto-agent.md](../agents/poteto-agent.md) | `c3ed187a871600cf496f954417634587df9fdf55` |
| [comment-sicko.md](comment-sicko.md) | [agents/comment-sicko.md](../agents/comment-sicko.md) | `f3afb7057ff87b9cb1eff0ada0c6b5c7d1ecc5fa` |
| [generalPurpose.md](generalPurpose.md) | Adapter-owned. No upstream agent file. | Repository baseline `13d9db81250162bf5a466b1a41e98f21cd11e7a7`. |

The prompt bodies are deliberate translations, not automatically synchronized copies. Adapter-loading instructions live in each definition's Pi section so fresh children read the shared guide in their own sessions. Parent-session loading starts in poteto-mode or an explicit standalone-skill setup instruction, not a root or global agent file. Pi frontmatter controls tools, context, and background execution. Models remain selected by the parent.

Poteto delegates require the parent to supply the absolute poteto-mode skill path. Comment Sicko receives scoped file paths or a readable diff file. It reports proposed deletions without changing files. Its original prompt body is preserved, with Pi limitations in a separate section.

`generalPurpose` is a minimal local compatibility agent, not an extracted Cursor or Claude Code prompt. It uses Pi's normal base prompt and the specialist task supplied by the parent.

None of these definitions receives MCP tools. Comment Sicko alone enables `allowNestedSubagents` and restricts descendants to `generalPurpose` for how and why investigations. Poteto delegates and general-purpose children do not themselves delegate. Depth and inherited capability ceilings still apply. Comment Sicko's own file tools are read-only, but its general-purpose children have Bash and write tools. Each child task must forbid edits. This is not a read-only sandbox for the whole subtree.

## Register the agents

1. Install and enable pi-subagents in Pi.
2. Add the absolute path to this directory to `subagents.agentScanDirs` in `~/.pi/agent/settings.json`. Preserve existing entries and unrelated settings.

```json
{
	"subagents": {
		"agentScanDirs": ["/root/pstack/pi-agents"]
	}
}
```

3. Run `/reload` in Pi.
4. Call `subagent` with `{"action":"list"}`. Confirm `poteto-agent`, `generalPurpose`, and `comment-sicko` are listed.

These user-level settings make the definitions available outside the pstack checkout. Adjust the absolute path if the checkout moves. See the [Pi adapter](../docs/harness/pi.md) for launch translations and limitations.

## Review upstream changes

Run these commands from the pstack checkout to inspect changes since the recorded source commits.

```bash
git log c3ed187a871600cf496f954417634587df9fdf55..HEAD -- agents/poteto-agent.md
git diff c3ed187a871600cf496f954417634587df9fdf55 HEAD -- agents/poteto-agent.md
git log f3afb7057ff87b9cb1eff0ada0c6b5c7d1ecc5fa..HEAD -- agents/comment-sicko.md
git diff f3afb7057ff87b9cb1eff0ada0c6b5c7d1ecc5fa HEAD -- agents/comment-sicko.md
```

Translate relevant prompt changes into the matching file here. Keep Pi-specific tool restrictions and launch behavior explicit. Update the recorded source commit after reviewing the changes. Run `/reload` and smoke-test each changed definition before committing it.
