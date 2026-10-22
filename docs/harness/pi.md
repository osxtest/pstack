# Pstack in Pi

Pstack skills use Cursor names. In Pi with pi-subagents, read this adapter once per session before executing harness-specific instructions. These mappings take precedence over Cursor-specific launch instructions. `<pstack>` means the checkout containing `skills/`, `pi-agents/`, and `docs/`.

## Setup

Register the definitions using the [Pi agent setup](../../pi-agents/README.md#register-the-agents). The definitions live in `<pstack>/pi-agents/`. They do not change pi-subagents itself.

The Harness section of poteto-mode requests this adapter read and applies its mappings to the skills and playbooks it invokes. Standalone skills do not automatically load this document. Before using one in a fresh Pi session, explicitly ask the agent to read this file by its absolute path. No root or global agent file is modified. Each fresh Pi child has its own adapter-loading instruction in its definition and must not rely on the parent's read.

Invoke the main skill with `/skill:poteto-mode`. A bare `/poteto-mode` command is not provided by this adapter. Skills with `disable-model-invocation: true` are intentionally absent from Pi's automatic skill advertisement. Read a routed skill by its absolute file path when the workflow calls for it.

## Tools

| Cursor instruction | Pi translation |
| --- | --- |
| `Task` | `subagent`. Enable it with `subagents_enable` if this session exposes that tool instead. |
| `AskQuestion` | Use a structured-question tool if available. Otherwise ask in chat with numbered options. |
| Open a todolist | Use a todo tool if available. Otherwise keep a checklist in chat and update it at phase boundaries. |
| Run a pstack skill | Read `<pstack>/skills/<name>/SKILL.md` and follow it. User commands use `/skill:<name>`. |
| `Read`, `Grep`, `Glob`, `Shell` | Use available Pi file tools or Bash. Read files with `read`. |

## Agent discovery

Use the live tool to inspect this installation.

```text
subagent({ action: "list" })
subagent({ action: "models" })
subagent({ action: "guide", options: { topic: "tool-reference/execution-parameters" } })
```

The registered agents are `poteto-agent`, `generalPurpose`, and `comment-sicko`. The first requires an absolute poteto-mode skill path in its task. The second does not automatically load poteto-mode. The third limits its own file access to read, grep, find, and ls. It can launch `generalPurpose` for how and why investigations. Pi also supplies nested-delegation and supervisor tools. Supply its scoped files or a readable diff file and the absolute paths of any required skills. The parent obtains a default Git diff when the calling skill requires one.

## Launch fields

| Cursor field | Pi translation |
| --- | --- |
| `subagent_type` | `agent`. Use the registered agent name unchanged. |
| `prompt` | `task`. Include scope, authority, file paths, validation, and expected output. |
| `run_in_background: true` | `async: true`. |
| `readonly: true` | No equivalent launch field. State the no-edit constraint in the task and check for changes afterward. Bash remains write-capable, so this is not an enforced read-only sandbox. |
| `readonly: false` | No equivalent launch field. Select an agent whose actual tools meet the task. This does not grant MCP access. |
| `environment: "local"` | Set `cwd` to the intended local checkout. |
| `environment: "cloud"` | Use an isolated local worktree when the task only needs isolation. Set `worktree: true` only when the repository meets pi-subagents' cleanliness requirements. A task requiring a real cloud machine remains blocked. |
| `cloud_base_branch` | Use the supported `options.baseRef` for a managed worktree, after checking the live guide. Do not substitute a different branch silently. |
| `file_attachments` | Include absolute readable file paths in `task`. |
| `resume` | Fresh agents remain the default. Use pi-subagents' retained-child controls only when the workflow needs state that lives in that child. |
| Tool allowlists | Configure `tools` in the agent definition. Do not invent `options.tools` on a launch. |

Omit Cursor-only syntax, but never discard its meaning silently. Report a missing isolation, permission, or capability requirement before proceeding with weaker behavior.

A single-agent launch uses the same tool for every agent.

```text
subagent({
	agent: "poteto-agent",
	task: "Read /root/pstack/skills/poteto-mode/SKILL.md in full, including its Principles section, before any work. Implement only the assigned change in the supplied scope.",
	cwd: "/path/to/project",
	model: "openai/gpt-6.1-sol:medium",
	async: true
})
```

Resolve the model from the live registry rather than assuming this example is available. For parallel or dependent work, read the installed pi-subagents skill and its workflow guide. Use the supported workflow API, not several invented Cursor `Task` objects.

Native background completion notifies the parent. Do not poll, sleep, or call `bg_wait` merely because a native child is running. Continue safe independent work or yield until the completion notification arrives. A launch failure is not permission to switch to an external CLI runner silently.

## Models

Read `~/.agents/pstack-models.md` if it exists. Select the role named by the calling skill. Resolve that value to an exact live `provider/model` ID. Leave `model` unset for `auto` or `inherit-parent`.

Pi accepts a thinking suffix such as `openai/gpt-6.1-sol:medium`. The live tool may also expose `options.thinking`. Do not append Cursor's `-xhigh` or `-fast` strings to a Pi model ID. If a configured model is unavailable, report that fact and the explicit replacement rather than pretending the original selection succeeded.

The definitions do not pin model or thinking defaults. `comment-sicko` has `acceptanceRole: read-only`. That acceptance label does not enforce permissions. Its restricted tool list supplies the file-access restriction.

## Nested delegation

Pi-subagents supports nested delegation through `allowNestedSubagents: true` or an explicit `subagent` tool entry. An empty `allowedAgents` list denies descendants even when nesting is enabled. Inherited depth and capability ceilings remain authoritative.

Comment Sicko enables nesting and explicitly lists `subagent` alongside its file tools. With an explicit tool allowlist, the installed runtime still filters available tools through that list. The flag authorizes nesting, but the callable tool must survive that filter. Comment Sicko permits only `generalPurpose` children for how and why investigations. Its own tools remain read-only. Its children have Bash and write tools, so each task must explicitly forbid edits and preserve the parent's scope. This is not an enforced read-only sandbox for the subtree. `generalPurpose` cannot launch further descendants in this configuration.

The calling skills do not need different investigation prompts. Read this adapter before dispatch, translate their launch fields, and use the child-safe tool schema actually provided. Pass each child the required files, specialist prompt, model, and evidence requirements. Depth defaults to two in pi-subagents when no stricter setting applies. Do not assume Cursor's depth-three guarantee or increase global depth silently.

Poteto delegates still have nesting disabled. Owner workflows that require them to launch helpers need a separate authorization change. A skill requesting delegation is not by itself a runtime capability grant.

## Deferred capabilities

These definitions explicitly disable ambient extensions. They do not supply MCP tools, even when the parent has them. A workflow needing unavailable tools must report the missing requirement rather than claim completion.

MCP-dependent instructions occur in `skills/why/` and `skills/reflect/`. `skills/recall/SKILL.md` also delegates shared-record searches to `why`. Cursor's statement that readonly mode strips MCP is not a Pi capability rule.

Nested-owner assumptions occur in `skills/poteto-mode/playbooks/feature.md`, `orchestrate.md`, `autopilot-full.md`, `autopilot-stack.md`, and generated owner plans from `multi-phase-plan.md`. Keep their capability-dependent work explicit. Comment Sicko's investigation grant does not enable these owner trees or replace an independent verification gate with an author's self-check.

Forge CLIs, Bun, browser drivers, and other external programs remain separate dependencies. Registering agent names does not install them or prove their workflows work.
