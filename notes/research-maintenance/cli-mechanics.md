# CLI mechanics for a plugin health-check command

Research note. Read-only verification against the official Claude Code documentation at
`code.claude.com/docs`, plus the public `anthropics/claude-code` issue tracker where the docs
are silent.

- **All sources accessed 2026-08-11.**
- Every claim below carries its source URL. Anything the docs do not state is listed in the
  final **NOT VERIFIED** section instead of being guessed.
- Scope note: this file documents *mechanics only*. It does not propose or design the
  health-check command.

---

## 1. `claude plugin list` — documentation, scope, source path, JSON output

**Primary source:** <https://code.claude.com/docs/en/plugins-reference#plugin-list> (accessed 2026-08-11)
**Secondary:** <https://code.claude.com/docs/en/cli-reference> (accessed 2026-08-11)

### Where it is documented

The CLI reference does **not** document the subcommands. It only carries the parent row and
points elsewhere:

> | `claude plugin` | Manage Claude Code [plugins](/docs/en/plugins). Alias: `claude plugins`. See [plugin reference](/docs/en/plugins-reference#cli-commands-reference) for subcommands | `claude plugin install code-review@claude-plugins-official` |

The real documentation lives in the plugins reference, under **CLI commands reference**, which
opens with:

> Claude Code provides CLI commands for non-interactive plugin management, useful for scripting
> and automation.

### What `plugin list` outputs

Verbatim from the plugins reference:

> ### plugin list
>
> List installed plugins with their version, source marketplace, and enable status.
>
> ```bash
> claude plugin list [options]
> ```
>
> **Options:**
>
> | Option        | Description                                                    | Default |
> | :------------ | :------------------------------------------------------------- | :------ |
> | `--json`      | Output as JSON                                                 |         |
> | `--available` | Include available plugins from marketplaces. Requires `--json` |         |
> | `-h, --help`  | Display help for command                                       |         |

**Answer on scope:** the documented output fields are **version, source marketplace, and enable
status**. Install scope (`user`/`project`/`local`) is **not** listed as an output field. See
NOT VERIFIED #1.

**Answer on source path:** **not** listed as an output field of `plugin list`. See NOT VERIFIED #1.
(By contrast, `claude plugin marketplace list --json` *is* documented to emit a path —
see §1.3 below — so the omission for `plugin list` appears deliberate rather than accidental.)

**Answer on JSON / non-interactive:** **Yes.** `--json` is documented. The whole
`claude plugin ...` family is explicitly framed as "non-interactive plugin management, useful
for scripting and automation."

### 1.1 Which plugins `claude plugin list` covers (important edge cases)

Verbatim:

> Within an interactive session, `/plugin list` prints a similar listing inline, but it covers
> marketplace-installed plugins only:
>
> * Plugins loaded from skills directories appear in the `/plugin` interface and in
>   `claude plugin list`, but not in the inline `/plugin list` output.
> * Plugins loaded for the session with `--plugin-dir` or `--plugin-url` appear in the `/plugin`
>   interface, and in `claude plugin list` only when the same flag precedes the subcommand, as in
>   `claude --plugin-dir <dir> plugin list`. They have no installed record, so a bare
>   `claude plugin list` doesn't show them.
>
> The interactive form accepts `--enabled` or `--disabled` to show only plugins in that state,
> and `ls` as a shorthand for `list`.

Practical consequence for a probe: a plugin under active development via `--plugin-dir` is
**invisible** to a bare `claude plugin list`; the flag must precede the subcommand.

### 1.2 `claude plugin details <name>` — the component inventory command

This is the documented way to get a plugin's component inventory non-interactively. Verbatim:

> ### plugin details
>
> Show a plugin's component inventory and projected token cost. The output lists all components
> the plugin contributes, grouped as Skills, Agents, Hooks, MCP servers, and LSP servers, along
> with an estimate of how many tokens it adds to each session. The Skills group includes both
> `skills/` and `commands/` entries.
>
> ```bash
> claude plugin details <name>
> ```

Documented example output:

```
dependency-guard 1.2.0
  Dependency analysis for Claude Code sessions
  Source: dependency-guard@example-marketplace

Component inventory
  Skills (2)  scan-dependencies, review-changes
  Agents (0)
  Hooks (1)  SessionStart  (harness-only — no model context cost)
  MCP servers (0)
  LSP servers (0)

Projected token cost
  Always-on:   ~180 tok   added to every session
...
```

Only `-h, --help` is documented as an option — **no `--json` flag is documented for
`plugin details`** (see NOT VERIFIED #2).

Corroborated from the user-facing side at
<https://code.claude.com/docs/en/discover-plugins#manage-installed-plugins> (accessed 2026-08-11):

> The detail view shows the components the plugin contributes: commands, skills, agents, hooks,
> MCP servers, and LSP servers. The same inventory is available from the command line with
> `claude plugin details`.

### 1.3 `claude plugin validate` — schema/frontmatter checker

From <https://code.claude.com/docs/en/plugins-reference#common-issues> (accessed 2026-08-11):

> Run `claude plugin validate ./my-plugin` or `/plugin validate ./my-plugin`, where `./my-plugin`
> is your plugin directory, to check `plugin.json`, skill/agent/command frontmatter, and
> `hooks/hooks.json` for syntax and schema errors

From <https://code.claude.com/docs/en/plugins#submit-your-plugin-to-the-community-marketplace>
(accessed 2026-08-11):

> When validation passes, Claude Code prints `✔ Validation passed`, or
> `✔ Validation passed with warnings` if there are warnings. Warnings don't fail validation;
> add `--strict` to treat them as errors.

### 1.4 `claude plugin marketplace list --json` (does carry a path)

From <https://code.claude.com/docs/en/plugin-marketplaces#plugin-marketplace-list> (accessed 2026-08-11):

> With `--json`, each entry includes `name`, `source`, an `installLocation` field with the local
> cache path where the marketplace is stored, and source-specific fields: `repo` for GitHub
> sources, `url` for git and URL sources, and `path` for local sources. GitHub and git sources
> also include a `ref` field when the marketplace was added with a pinned branch or tag.

So a **marketplace's** local path is documented and machine-readable; an **installed plugin's**
path is not documented as an output field of `plugin list`.

---

## 2. Listing installed commands/skills and registered agents

### 2.1 `claude agents` is NOT an agent-definition lister

**Source:** <https://code.claude.com/docs/en/cli-reference> (accessed 2026-08-11). Full verbatim row:

> | `claude agents` | Open [agent view](/docs/en/agent-view) to monitor and dispatch parallel
> background sessions. Use `--cwd <path>` to show only sessions started under that directory, or
> `--json` to print active sessions as a JSON array for scripting (`--json --all` also includes
> completed background sessions). Pass `--permission-mode`, `--model`, `--effort`, or `--agent` to
> set [defaults for dispatched sessions](/docs/en/agent-view#permission-mode-model-and-effort).
> Accepts `--settings`, `--add-dir`, `--plugin-dir`, and `--mcp-config` like the top-level `claude`
> command. **Opening agent view requires an interactive terminal** | `claude agents --json` |

This is the background-session **agent view**, not a listing of subagent definitions. `--json` IS
documented and does work non-interactively (it prints an array of dispatched background
*sessions* — id, cwd, status — despite the interactive-terminal requirement applying to the
visual view, not to `--json` mode). Anything that assumes `claude agents` or `claude agents --json`
enumerates `agents/*.md` subagent **definitions** is wrong: it enumerates running/completed
**dispatched sessions**, a different noun entirely. See NOT VERIFIED #9.

The full documented CLI command table (verbatim, same page) contains **no** `claude skills`,
`claude commands`, or `claude hooks` command:

> `claude`, `claude "query"`, `claude -p "query"`, `cat file | claude -p "query"`, `claude -c`,
> `claude -c -p "query"`, `claude -r "<session>" "query"`, `claude update`, `claude gateway`,
> `claude install [version]`, `claude auth login`, `claude auth logout`, `claude auth status`,
> `claude agents`, `claude attach <id>`, `claude auto-mode defaults`, `claude auto-mode reset`,
> `claude daemon status`, `claude daemon stop --any`, `claude doctor`,
> `claude import [codex|gemini]`, `claude logs <id>`, `claude mcp`, `claude mcp login <name>`,
> `claude mcp logout <name>`, `claude plugin`, `claude project purge [path]`,
> `claude remote-control`, `claude respawn <id>`, `claude rm <id>`, `claude setup-token`,
> `claude stop <id>`, `claude ultrareview [target]`

### 2.2 `/agents` no longer lists anything useful

**Source:** <https://code.claude.com/docs/en/commands> and
<https://code.claude.com/docs/en/sub-agents> (both accessed 2026-08-11). Verbatim:

> | `/agents` | As of v2.1.198, running `/agents` prints a reminder to ask Claude to create or
> manage [subagents](/docs/en/sub-agents), or to edit `.claude/agents/` or `~/.claude/agents/`
> directly. On v2.1.197 and earlier, opens an interactive interface for creating and managing
> subagent configurations |

And from the subagents page:

> As of v2.1.198, the `/agents` command no longer opens the interactive creation wizard; running
> it prints a reminder to ask Claude or edit `.claude/agents/` directly. Subagent files,
> frontmatter fields, and the `.claude/agents/` and `~/.claude/agents/` locations are unchanged;
> only the terminal wizard is removed.

> On Claude Code v2.1.197 and earlier, `/agents` opens an interactive wizard with a **Running**
> tab that lists live subagents and a **Library** tab for creating, editing, and deleting them.

**Conclusion: `/agents` is not a usable inventory source on current versions.**

### 2.3 `/context` is the documented place where agents appear

**Source:** <https://code.claude.com/docs/en/plugins#test-your-plugins-locally> (accessed 2026-08-11):

> * Check that agents appear in `/context` under Custom Agents, or @-mention one by its scoped name

The same instruction repeats in the migration walkthrough on that page: "check that agents appear
in `/context`".

`/context` itself, from <https://code.claude.com/docs/en/commands> (accessed 2026-08-11):

> | `/context [all]` | Visualize current context usage as a colored grid. Shows optimization
> suggestions for context-heavy tools, memory bloat, and capacity warnings... In
> [fullscreen mode](/docs/en/fullscreen), `/context` collapses the per-item breakdown to keep the
> grid visible. Pass `all` to expand it |

Whether `/context` renders usefully in `-p` mode is NOT VERIFIED (#3).

### 2.4 Other listing surfaces

| Surface | What it lists | Interactive? | Source |
| :-- | :-- | :-- | :-- |
| `claude plugin list [--json]` | installed plugins: version, source marketplace, enable status | No (CLI) | plugins-reference |
| `claude plugin details <name>` | per-plugin component inventory (Skills / Agents / Hooks / MCP / LSP) | No (CLI) | plugins-reference |
| `claude plugin marketplace list --json` | marketplaces + `installLocation` path | No (CLI) | plugin-marketplaces |
| `/plugin` | 4-tab panel: Discover, Installed, Marketplaces, Errors | **Yes, interactive panel** | discover-plugins |
| `/plugin list [--enabled\|--disabled]` | inline listing, marketplace-installed plugins only | prints inline | discover-plugins, plugins-reference |
| `/hooks` | read-only browser of all configured hooks, with source labels | **Yes, menu** | hooks |
| `/skills [<name>]` | skills browser | **Yes, browser** | commands |
| `/context [all]` | context grid incl. Custom Agents | prints inline | commands, plugins |
| `/help` → "Custom commands" tab | plugin skills under their namespace | **Yes, tabbed** | plugins |
| `claude --debug` | plugin load details incl. "Skill, agent, and hook registration" | No (stderr) | plugins-reference |

`/plugin` tabs, verbatim from <https://code.claude.com/docs/en/discover-plugins> (accessed 2026-08-11):

> * **Discover**: browse available plugins from all your marketplaces
> * **Installed**: view and manage your installed plugins
> * **Marketplaces**: add, remove, or update your added marketplaces
> * **Errors**: view any plugin loading errors

Also verbatim, on the Installed tab (this is where install scope *is* surfaced):

> Run `/plugin` and go to the **Installed** tab to view, enable, disable, or uninstall your
> plugins. The list is grouped by scope and sorted so you see problems first

And a hard constraint on `/plugin`:

> `/plugin` opens an interactive panel in the terminal CLI. If Claude replies that `/plugin`
> isn't available in this environment, use the [plugin browser](/docs/en/desktop#install-plugins)
> in the Claude desktop app, or declare the plugin under
> [`enabledPlugins`](/docs/en/settings#enabledplugins) in `.claude/settings.json` for cloud sessions.

And, on scripting:

> * When you run `/plugin disable`, `/plugin enable`, or `/plugin uninstall`, Claude Code opens
>   the plugin panel to apply the change and leaves it open. Press **Esc** to close the panel
>   before typing another command.
> * For scripting, use the `claude plugin` shell commands instead, which don't open the panel.

### 2.5 What runs non-interactively

**Source:** <https://code.claude.com/docs/en/headless#auto-approve-tools> (accessed 2026-08-11), verbatim:

> User-invoked [skills](/docs/en/skills) and custom commands work in `-p` mode: include
> `/skill-name` in the prompt string and Claude Code expands it before running. Built-in commands
> that only run in the terminal interface, such as `/login`, aren't available in `-p` mode.
> `/model`, `/effort`, `/fast`, `/color`, and `/rename` accept the value as an argument, for
> example `/model sonnet`, and `/mcp` with no argument prints a text summary of server status;
> these forms require Claude Code v2.1.205 or later and follow each command's
> [availability notes](/docs/en/commands#all-commands). To change a setting from a `-p`
> invocation, pass `key=value` to `/config`, for example `/config thinking=false`.

The documented non-interactive escape hatches are therefore: the `claude plugin ...` shell
commands, `claude --debug`, `--output-format stream-json` (see §6.1), and user-invoked
skills inside the `-p` prompt string. Built-in **interactive panels** (`/plugin`, `/hooks`,
`/skills`) are not documented as producing output in `-p`; `/mcp` is the one explicitly
documented exception that degrades to a text summary.

---

## 3. Slash-command / skill frontmatter fields

**Current page:** <https://code.claude.com/docs/en/skills#frontmatter-reference> (accessed 2026-08-11).

> **URL note:** `https://code.claude.com/docs/en/slash-commands` resolves to the page titled
> **"Extend Claude with skills"** at `/docs/en/skills`. Custom commands and skills have been
> merged. Verbatim from that page:
>
> > **Custom commands have been merged into skills.** A file at `.claude/commands/deploy.md` and
> > a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way. Your
> > existing `.claude/commands/` files keep working.
>
> Built-in commands live on a separate page: <https://code.claude.com/docs/en/commands>.

All five requested fields **still exist**. Verbatim rows from the frontmatter reference table:

| Field | Required | Documented description (verbatim) |
| :-- | :-- | :-- |
| `disable-model-invocation` | No | Set to `true` to prevent Claude from automatically loading this skill. Use for workflows you want to trigger manually with `/name`. Also prevents the skill from being [preloaded into subagents](/docs/en/sub-agents#preload-skills-into-subagents). As of v2.1.196, also prevents the skill from running when a [scheduled task](/docs/en/scheduled-tasks) fires with the skill as its prompt. Default: `false`. |
| `argument-hint` | No | Hint shown during autocomplete to indicate expected arguments. Example: `[issue-number]` or `[filename] [format]`. |
| `allowed-tools` | No | Tools Claude can use without asking permission during the turn that invokes this skill. The grant clears when you send your next message. Accepts a space- or comma-separated string, or a YAML list. See [Pre-approve tools for a skill](#pre-approve-tools-for-a-skill). |
| `model` | No | Model to use when this skill is active. The override applies for the rest of the current turn and is not saved to settings; the session model resumes on your next prompt. Accepts the same values as [`/model`](/docs/en/model-config), or `inherit` to keep the active model. […] With `context: fork`, the value sets the [forked subagent's model](#run-skills-in-a-subagent) instead […] |
| `effort` | No | [Effort level](/docs/en/model-config#adjust-effort-level) when this skill is active. Overrides the session effort level. Default: inherits from session. Options: `low`, `medium`, `high`, `xhigh`, `max`; available levels depend on the model. |

Other fields documented on the same table, relevant to a health check:
`name`, `description`, `when_to_use`, `arguments`, `user-invocable`, `disallowed-tools`,
`context`, `agent`, `background`, `hooks`, `paths`, `shell`, `metadata`, `license`,
`compatibility`.

Two gotchas worth recording:

1. **Boolean parsing widened.** Verbatim: "Boolean fields accept `yes`, `no`, `on`, `off`, `1`,
   and `0` in any letter case, in addition to `true` and `false`. Before v2.1.218, Claude Code
   recognized only `true` and `false`."
2. **`argument-hint` is Claude-Code-only.** Verbatim from
   <https://code.claude.com/docs/en/skills#using-skill-frontmatter-outside-claude-code>:
   only `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools` are valid
   for "claude.ai skill uploads, the Skills API, and packaging with `package_skill.py`", and
   including a Claude-Code-only field is a **hard error** on those paths:
   > ```
   > Unexpected key(s) in SKILL.md frontmatter: argument-hint. Allowed properties are: allowed-tools, compatibility, description, license, metadata, name
   > ```
   Inside Claude Code — including plugin skills — every field in the table is accepted.

Also relevant: `user-invocable` vs `disable-model-invocation` are **not** interchangeable.
Verbatim: "The `user-invocable` field only controls menu visibility, not Skill tool access. Use
`disable-model-invocation: true` to block programmatic invocation."

---

## 4. Plugin hooks: `permissionDecision: "deny"`, session-start loading, listing hooks

**Source:** <https://code.claude.com/docs/en/hooks> and
<https://code.claude.com/docs/en/plugins-reference#hooks> (both accessed 2026-08-11).

### 4.1 `deny` is still the documented blocking mechanism — CONFIRMED

Documented `PreToolUse` output shape, verbatim:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Destructive command blocked by hook"
  }
}
```

Documented `permissionDecision` values: `"allow"`, `"deny"`, `"ask"`, **and `"defer"`**.
(`defer` is a value to be aware of; it was not in the original question.)

On the blocking behaviour, verbatim from the walkthrough:

> Claude Code reads the JSON decision, blocks the tool call, and shows Claude the reason.

and

> The hook can deny the call, but staying silent doesn't approve it.

`PreToolUse` is also listed in the plugins reference event table as:

> | `PreToolUse` | Before a tool call executes. Can block it |

### 4.2 Plugin hooks and session start

The docs state the *scope* rather than the literal words "load at session start". Verbatim from
the hooks page location table:

> | Plugin `/hooks/hooks.json` | When plugin is enabled | Yes, bundled with the plugin |

and:

> When a plugin is enabled, its hooks merge with your user and project hooks.

> Hook entries merge across settings levels rather than replacing each other: user, project, and
> local settings add their own hooks without removing managed ones…

The strongest direct evidence that plugin hooks are bound at session start (not re-read live) is
from <https://code.claude.com/docs/en/plugins-reference#edit-reload-and-disable-a-skills-directory-plugin>
(accessed 2026-08-11), verbatim:

> Changes you make to a skill's `SKILL.md` take effect immediately in the current session. Changes
> to the plugin's other components, such as `hooks/`, `.mcp.json`, `agents/`, and
> `output-styles/`, do not. Run `/reload-plugins` or restart Claude Code to pick those up.

and from the environment-variables section:

> When a plugin updates mid-session, hook commands, monitors, MCP servers, and LSP servers keep
> using the previous version's path. Run `/reload-plugins` to switch hooks, MCP servers, and LSP
> servers to the new path; monitors require a session restart.

Note the asymmetry for **non-plugin** hooks, verbatim from the hooks page:

> Direct edits to hooks in settings files are normally picked up automatically by the file watcher.

So: settings-file hooks are watched; **plugin** hook definitions need `/reload-plugins` or a
restart. See NOT VERIFIED #4 for the exact wording "plugin hooks load at session start".

### 4.3 Listing active hooks: `/hooks` exists and is read-only — CONFIRMED

Verbatim from <https://code.claude.com/docs/en/hooks> (section "The `/hooks` menu"):

> Type `/hooks` in Claude Code to open a read-only browser for your configured hooks. The menu
> shows every hook event with a count of configured hooks, lets you drill into matchers, and shows
> the full details of each hook handler. Use it to verify configuration, check which settings file
> a hook came from, or inspect a hook's command, prompt, or URL.

> Selecting a hook opens a detail view showing its event, matcher, type, source file, and the full
> command, prompt, or URL. The menu is read-only: to add, modify, or remove hooks, edit the
> settings JSON directly or ask Claude to make the change.

Documented source labels in that menu: `User Settings`, `Project Settings`, `Local Settings`,
**`Plugin Hooks`**, `Session Hooks`, `Built-in Hooks`.

The `/docs/en/commands` row is terser:

> | `/hooks` | View [hook](/docs/en/hooks) configurations for tool events |

**This is an interactive menu.** Non-interactive alternatives that the docs do mention:
`claude --debug` ("Skill, agent, and hook registration"), the debug log
(<https://code.claude.com/docs/en/hooks#debug-hooks> — "Claude Code records which hooks matched,
their exit codes, and their output in the debug log"), and the `-p` flag
`--include-hook-events` (listed in the CLI reference). Whether `/hooks` prints anything in `-p`
is NOT VERIFIED (#3).

---

## 5. Local-marketplace install at user scope: live reference or frozen copy?

**Answer: the docs say the plugin is COPIED into a cache, not referenced live.** This is stated
three times across two pages.

**Source A:** <https://code.claude.com/docs/en/plugins-reference#plugin-caching-and-file-resolution>
(accessed 2026-08-11). Verbatim:

> Plugins are specified in one of two ways:
>
> * Through `claude --plugin-dir` or `claude --plugin-url`, for the duration of a session.
> * Through a marketplace, installed for future sessions.
>
> For security and verification purposes, Claude Code copies *marketplace* plugins to the user's
> local **plugin cache** (`~/.claude/plugins/cache`) rather than using them in-place.
>
> Each installed version is a separate directory in the cache. When you update or uninstall a
> plugin, the previous version directory is marked as orphaned and removed automatically 14 days
> later. The grace period lets concurrent Claude Code sessions that already loaded the old version
> keep running without errors.

And, confirming the copy is a boundary, not a view:

> ### Path traversal limitations
>
> Installed plugins cannot reference files outside their directory. Paths that traverse outside the
> plugin root (such as `../shared-utils`) will not work after installation because those external
> files are not copied to the cache.

**Source B:** <https://code.claude.com/docs/en/plugin-marketplaces> (accessed 2026-08-11).
In the "Walkthrough: create a local marketplace" section — i.e. the exact scenario in the
question, `"source": "./plugins/quality-review-plugin"` added via `/plugin marketplace add ./my-marketplace`
— the page attaches this note, verbatim:

> **How plugins are installed**: when users install a plugin, Claude Code copies the plugin
> directory to a cache location. This means plugins can't reference files outside their directory
> using paths like `../shared-utils`, because those files won't be copied.

And in the plugin-sources section, verbatim:

> After Claude Code clones or downloads a plugin to the local machine, it copies the plugin into
> the local versioned plugin cache at `~/.claude/plugins/cache`.

And in troubleshooting ("Files not found after installation"), verbatim:

> **Cause**: Plugins are copied to a cache directory rather than used in-place.

**Contrast — the two documented ways to get live/in-place behaviour:**

1. **`--plugin-dir`** (session-scoped, no install). Verbatim from
   <https://code.claude.com/docs/en/plugins#test-your-plugins-locally>:
   > Use the `--plugin-dir` flag to test plugins during development. This loads your plugin
   > directly without requiring installation.
   >
   > When a `--plugin-dir` plugin has the same name as an installed marketplace plugin, the local
   > copy takes precedence for that session. This lets you test changes to a plugin you already
   > have installed without uninstalling it first. The exception is plugins that managed settings
   > force-enable or force-disable: `--plugin-dir` cannot override those.
   >
   > As you make changes to your plugin, run `/reload-plugins` to pick up the updates without
   > restarting.

2. **Skills-directory plugins** (`@skills-dir`), which are the one documented *installed-like*
   path that is explicitly **not** copied. Verbatim from
   <https://code.claude.com/docs/en/plugins-reference#skills-directory-plugins>:
   > Any folder under a skills directory that contains a `.claude-plugin/plugin.json` manifest is
   > loaded as a plugin named `<name>@skills-dir` on the next session, with no marketplace and no
   > install step. […] **Unlike a marketplace install, the plugin is discovered in place rather
   > than copied into the plugin cache.**

**Version/freshness consequence** (relevant because a local dev marketplace usually has no git
version). From <https://code.claude.com/docs/en/plugins-reference#version-management>, the version
resolution order ends with:

> 5. `unknown`, for `npm` sources or local directories not inside a git repository

and version is the update signal:

> Claude Code uses the plugin's version as the cache key that determines whether an update is
> available. When you run `/plugin update` or auto-update fires, Claude Code computes the current
> version and skips the update if it matches what's already installed.

Also, from <https://code.claude.com/docs/en/discover-plugins#configure-auto-updates>:

> Official Anthropic marketplaces have auto-update enabled by default. Third-party and local
> development marketplaces have auto-update disabled by default.

Net: a user-scope install from a local marketplace is a **frozen copy** under
`~/.claude/plugins/cache`, auto-update is **off by default** for that marketplace, and if the
plugin declares an explicit `version` that you don't bump, the cached copy is what keeps loading.

Symlink handling for local-path installs, verbatim:

> For plugins installed with `--plugin-dir` or from a local path, only symlinks that resolve
> within the plugin's own directory are preserved. All others are skipped.

---

## 6. `claude -p "<prompt>"` headless / print mode

**Primary source:** <https://code.claude.com/docs/en/headless> — page title "Run Claude Code
programmatically" (accessed 2026-08-11).
**Flag reference:** <https://code.claude.com/docs/en/cli-reference> (accessed 2026-08-11).

Verbatim from the CLI reference flags table:

> | `--print`, `-p` | Print response without interactive mode (see [Agent SDK documentation](/docs/en/agent-sdk/overview) for programmatic usage details) | `claude -p "query"` |

Verbatim from the headless page:

> To run Claude Code in non-interactive mode, pass `-p` with your prompt and the
> [CLI options](/docs/en/cli-reference) you need
>
> ```bash
> claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
> ```

> Add the `-p` (or `--print`) flag to any `claude` command to run it non-interactively.

> Claude Code exits with code 0 on success and a non-zero code when the run fails, so your scripts
> can branch on the exit status.

### 6.1 Do plugins load in `-p`? — YES by default

Verbatim (the `--bare` section, which is the negative proof):

> Add `--bare` to reduce startup time by skipping auto-discovery of hooks, skills, plugins, MCP
> servers, auto memory, and CLAUDE.md. **Without it, `claude -p` loads the same
> [context](/docs/en/how-claude-code-works#the-context-window) an interactive session would,**
> including anything configured in the working directory or `~/.claude`.

> Bare mode is useful for CI and scripts where you need the same result on every machine. A hook in
> a teammate's `~/.claude` or an MCP server in the project's `.mcp.json` won't run, because bare
> mode never reads them.

So: **`claude -p` without `--bare` loads plugins, hooks, skills, and MCP servers.** Adding
`--bare` deliberately disables all of that (and also stops reading OAuth credentials, requiring
`ANTHROPIC_API_KEY`). Bare mode can still load one plugin explicitly:

> | A plugin | `--plugin-dir <path>`, `--plugin-url <url>` |

### 6.2 Single-turn probe suitability — YES

`claude -p "prompt"` runs and exits. Structured output is documented:

> Use `--output-format` to control how responses are returned:
>
> * `text` (default): plain text output
> * `json`: structured JSON with result, session ID, and metadata
> * `stream-json`: newline-delimited JSON for real-time streaming

### 6.3 The machine-readable plugin inventory inside `-p`: the `system/init` event

This is the single most useful mechanic for a health-check probe. Verbatim from the headless page
("Read session metadata" / "Fail CI when a plugin or MCP server doesn't load"):

> The `system/init` event reports session metadata including the model, tools, MCP servers, and
> loaded plugins. It is the first event in the stream unless startup events precede it

> | `plugins` | array | plugins that loaded successfully, each with `name` and `path` |
> | `plugin_errors` | array | plugin load-time errors, each with `plugin`, `type`, and `message`.
> Includes unsatisfied dependency versions and `--plugin-dir` load failures such as a missing path
> or invalid archive. Affected plugins are demoted and absent from `plugins`. The key is omitted
> when there are no errors |

> | `mcp_servers` | array | MCP servers in the session, each with `name` and `status` |
> | `mcp_server_errors` | array | `--mcp-config` entries skipped by config validation, each with
> `name`, `type`, and `message`. […] The key is omitted when there are no errors, so a CI gate can
> fail on a non-empty array. Requires Claude Code v2.1.219 or later |

**`plugins[].path` is the documented, machine-readable way to obtain a loaded plugin's install
path** — which `claude plugin list --json` is not documented to provide (see §1 and NOT VERIFIED #1).

Reached with:

```bash
claude -p "<prompt>" --output-format stream-json --verbose --include-partial-messages
```

Related flags documented for `-p`: `--include-hook-events`, `--forward-subagent-text`,
`--replay-user-messages`, `--json-schema`, `--input-format`.

### 6.4 Skills inside a `-p` prompt

Already quoted in §2.5 — user-invoked skills and custom commands **do** work in `-p` by putting
`/skill-name` in the prompt string.

---

## 7. `${CLAUDE_PLUGIN_ROOT}` — documented contexts and the command-markdown problem

**Source:** <https://code.claude.com/docs/en/plugins-reference#environment-variables> (accessed 2026-08-11).

Verbatim:

> Claude Code provides three variables for referencing paths:
>
> | Variable | Resolves to | Use it for |
> | `${CLAUDE_PLUGIN_ROOT}` | Absolute path to the plugin's installation directory | Scripts, binaries, and config files bundled with the plugin |
> | `${CLAUDE_PLUGIN_DATA}` | [Persistent directory](#persistent-data-directory) that survives plugin updates, created on first reference | Installed dependencies such as `node_modules` or Python virtual environments, generated code, and caches |
> | `${CLAUDE_PROJECT_DIR}` | The project root | Project-local scripts and config files |
>
> All three are exported as environment variables to hook processes and to MCP and LSP server
> subprocesses. Which fields substitute them inline depends on the plugin component:
>
> | Plugin component | Fields where placeholders resolve |
> | :-- | :-- |
> | **Skill and agent content** | **Anywhere the placeholder appears** |
> | Hook and monitor commands | Anywhere the placeholder appears |
> | MCP `stdio` servers | `command`, `args`, `env` |
> | MCP `http`, `sse`, `ws` servers | `url`, `headers`, `headersHelper` |
> | LSP servers | `command`, `args`, `env`, `workspaceFolder` |

**So the docs today claim `${CLAUDE_PLUGIN_ROOT}` DOES resolve inside skill and agent markdown
content, "anywhere the placeholder appears".** Since commands are skills
(`commands/*.md` files are skills — see §3), that row is the documented answer for command
markdown bodies.

Also documented:

> `${CLAUDE_PLUGIN_ROOT}` changes when the plugin updates. The previous version's directory
> remains on disk for about two weeks after an update before cleanup, but treat it as ephemeral
> and don't write state there.

> In hook commands, use [exec form](/docs/en/hooks#exec-form-and-shell-form) with `args` so each
> path is passed as one argument with no quoting. In shell-form hooks and monitor commands, wrap
> the variables in double quotes, as in `"${CLAUDE_PROJECT_DIR}/scripts/server.sh"`.

### 7.1 A documentation inconsistency worth flagging

The **skills** page has its own substitution table
(<https://code.claude.com/docs/en/skills#available-string-substitutions>, accessed 2026-08-11)
listing `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N`, `$name`, `${CLAUDE_SESSION_ID}`, `${CLAUDE_EFFORT}`,
`${CLAUDE_SKILL_DIR}`, `${CLAUDE_PROJECT_DIR}` — **`${CLAUDE_PLUGIN_ROOT}` is absent from it.**
And that page says, verbatim:

> Claude Code substitutes `${CLAUDE_SKILL_DIR}` and `${CLAUDE_PROJECT_DIR}` in two places: the
> skill's markdown content, and Bash rules in the [`allowed-tools`](#frontmatter-reference)
> frontmatter.

The skills page also documents `${CLAUDE_SKILL_DIR}` as plugin-aware, verbatim:

> | `${CLAUDE_SKILL_DIR}` | The directory containing the skill's `SKILL.md` file. **For plugin
> skills, this is the skill's subdirectory within the plugin, not the plugin root.** Use this in
> bash injection commands to reference scripts or files bundled with the skill, regardless of the
> current working directory. |

**The two pages disagree by omission**: plugins-reference says all three path variables resolve
anywhere in skill/agent content; the skills page names only `${CLAUDE_SKILL_DIR}` and
`${CLAUDE_PROJECT_DIR}` as substituted in markdown content. `${CLAUDE_SKILL_DIR}` is the safer
choice inside a plugin skill body.

### 7.2 Open issues about non-expansion (NOT official docs — issue tracker)

These are from `github.com/anthropics/claude-code/issues`, accessed 2026-08-11. They are **user
bug reports, not documentation**, and are recorded here only because the question asked whether a
known problem exists.

| # | Title | State (re-verified via `gh issue view`, 2026-08-11) | Note |
| :-- | :-- | :-- | :-- |
| [9354](https://github.com/anthropics/claude-code/issues/9354) | `[BUG] Fix ${CLAUDE_PLUGIN_ROOT} in command markdown OR support local project plugin installation` | **OPEN** (opened 2025-10-11; last activity 2026-04-22) | Reports the variable expands to an empty string in command markdown, e.g. `node ${CLAUDE_PLUGIN_ROOT}/scripts/analyzer.js` → `Error: Cannot find module '/scripts/analyzer.js'`. No maintainer fix visible in the issue body. A community-posted workaround (a `UserPromptSubmit` hook that injects the resolved path via `additionalContext` when the prompt starts with `/`) appeared 2026-03-29, and a different user confirmed hitting the bug fresh on 2026-04-22 ("i just banged my head against the wall trying to debug what was going on"). Still open as of this file's access date. |
| [44057](https://github.com/anthropics/claude-code/issues/44057) | `[BUG] $CLAUDE_PLUGIN_ROOT not substituted in user-invocable (slash command) skills` | **CLOSED** (opened 2026-04-06) | Reports the variable resolves correctly for model-invocable skills but not for skills with `disable-model-invocation: true`, where it resolves to the source directory instead of the cache path. Repro explicitly uses a **local directory marketplace** (`"source": "directory"`) — directly adjacent to §5. Links #38699 and #42564. Confirmed CLOSED; the specific closing reason (fixed vs. superseded) is not exposed by `gh issue view` and is NOT VERIFIED. |
| [52079](https://github.com/anthropics/claude-code/issues/52079) | `${CLAUDE_PLUGIN_ROOT}` is not expanded for `statusLine.command` (works for hooks/MCP/LSP/monitors) | **CLOSED** (opened 2026-04-22) | Not command-markdown, but same family — and its own title states hooks/MCP/LSP/monitors substitution already worked correctly even before this fix. |
| [47789](https://github.com/anthropics/claude-code/issues/47789) | `headersHelper` does not expand `${CLAUDE_PLUGIN_ROOT}` or set it as env var | **CLOSED** (opened 2026-04-14) | MCP `headersHelper` gap — consistent with §7's current substitution table, which now lists `headersHelper` as a field where the placeholder resolves. |
| [66557](https://github.com/anthropics/claude-code/issues/66557) | Stop hook: `$CLAUDE_PLUGIN_ROOT` not injected when running plugin hooks | not re-verified this pass (found via search only) | Hook-runner gap. |
| [43380](https://github.com/anthropics/claude-code/issues/43380) | Plugin hooks fail: `CLAUDE_PLUGIN_ROOT` not injected at hook execution time | **CLOSED** (opened 2026-04-04) | Hook-runner gap. |
| [65579](https://github.com/anthropics/claude-code/issues/65579) | `[BUG] Windows: ${CLAUDE_PLUGIN_ROOT}` left unexpanded in Claude Desktop (Cowork), PreToolUse Bash hook fully blocked | **CLOSED** (opened 2026-06-05) | Windows-specific; relevant since this repo runs on Windows. |

**The pattern that emerges from re-checking issue state on 2026-08-11: every adjacent
`${CLAUDE_PLUGIN_ROOT}`-substitution gap that was filed after #9354 — `statusLine.command`, MCP
`headersHelper`, hook-execution injection, and the Windows/Cowork case — is now CLOSED.** Only the
original report, specifically about **command markdown bodies**, remains open, with a fresh
first-hand confirmation as recently as 2026-04-22. That is consistent with two different
explanations the docs don't distinguish between: either the general substitution mechanism was
fixed everywhere except command markdown specifically, or command markdown was fixed for some
invocation paths (Claude-invoked) but not others (user-invoked / `disable-model-invocation: true`,
per #44057's repro). **No documented fix** for the command-markdown case appears in the official
docs; the docs assert the substitution works "anywhere the placeholder appears" in skill and agent
content (§7 table), while #9354 remains open asserting it does not for at least some command
invocations. Treat `${CLAUDE_PLUGIN_ROOT}` inside a command/skill markdown body as
**documented-but-contested**, verify empirically before a health check relies on it, and prefer
`${CLAUDE_SKILL_DIR}` (skills page, plugin-aware, not reported broken) or explicit runtime path
discovery when correctness matters.

---

## 8. Plugin `agents/*.md` and the `tools:` allowlist

**Current docs URLs (both accessed 2026-08-11):**
- Plugin-side: <https://code.claude.com/docs/en/plugins-reference#agents>
- Full reference: <https://code.claude.com/docs/en/sub-agents> (title "Create custom subagents"),
  frontmatter table at <https://code.claude.com/docs/en/sub-agents#supported-frontmatter-fields>

Verbatim from the plugins reference:

> ### Agents
>
> Plugins can provide specialized subagents for specific tasks that Claude can invoke
> automatically when appropriate.
>
> **Location**: `agents/` directory in plugin root
>
> **File format**: Markdown files describing agent capabilities
>
> ```markdown
> ---
> name: agent-name
> description: What this agent specializes in and when Claude should invoke it
> model: sonnet
> effort: medium
> maxTurns: 20
> disallowedTools: Write, Edit
> ---
>
> Detailed system prompt for the agent describing its role, expertise, and behavior.
> ```
>
> Plugin agents support `name`, `description`, `model`, `effort`, `maxTurns`, `tools`,
> `disallowedTools`, `skills`, `memory`, `background`, and `isolation` frontmatter fields. The only
> valid `isolation` value is `"worktree"`. For security reasons, `hooks`, `mcpServers`, and
> `permissionMode` are not supported for plugin-shipped agents.
>
> Agents appear in the [@-mention typeahead](/docs/en/sub-agents#invoke-subagents-explicitly) under
> their scoped name, such as `my-plugin:code-reviewer`, once the plugin is enabled.

### `tools:` as an allowlist — CONFIRMED

Verbatim from the subagents frontmatter table:

> | `tools` | No | [Tools](#available-tools) the subagent can use. **Inherits every tool available
> to subagents if omitted.** If no entry in the list resolves to a tool, the subagent usually
> [fails to launch](/docs/en/errors#agent-would-be-spawned-with-zero-tools) with an error naming
> the entries. To preload Skills into context, use the `skills` field rather than listing `Skill`
> here |
>
> | `disallowedTools` | No | Tools to deny, removed from inherited or specified list |

And in prose, verbatim:

> To restrict tools, use the `tools` field as an allowlist or the `disallowedTools` field as a
> denylist. This example uses `tools` to allow only Read, Grep, Glob, and Bash. The subagent can't
> edit files, write files, or use any MCP tools

> If both are set, `disallowedTools` is applied first, then `tools` is resolved against the
> remaining pool. A tool listed in both is removed.

Additional documented specifics:

> If you omit `Agent` from the `tools` list entirely, the agent can't spawn any subagents with the
> Agent tool.

> The `Agent(agent_type)` allowlist syntax applies only to an agent running as the main thread with
> `claude --agent`. In a subagent definition, listing `Agent` in `tools` lets that subagent spawn
> subagents of its own while the [depth limit](#let-subagents-spawn-their-own-subagents) allows it,
> but any type list inside the parentheses is ignored.

> To prevent a subagent from invoking skills entirely, omit `Skill` from the
> [`tools`](#available-tools) list or add it to `disallowedTools`.

Precedence note relevant to a health check, verbatim from
<https://code.claude.com/docs/en/plugins#convert-existing-configurations-to-plugins>:

> Project and user `.claude/agents/` definitions override same-named plugin agents, so the plugin
> version only takes effect once the originals are removed.

And the security carve-out, verbatim from the subagents page:

> For security reasons, plugin subagents don't support the `hooks`, `mcpServers`, or
> `permissionMode` frontmatter fields. These fields are ignored when loading agents from a plugin.

Live-reload behaviour for **non-plugin** agents, verbatim:

> Claude Code watches `~/.claude/agents/` and `.claude/agents/`. When you add or edit a subagent
> file on disk, or ask Claude to write one for you, Claude Code detects the change within a few
> seconds and the next delegation uses the updated definition, with no restart needed.

(For **plugin** agents, §4.2 applies: `agents/` changes need `/reload-plugins` or a restart.)

---

## NOT VERIFIED

Items the official docs do not state. Not guessed, not inferred.

1. **Whether `claude plugin list` (text or `--json`) includes install scope or the plugin's
   install path.** The docs describe the output only as "version, source marketplace, and enable
   status" (<https://code.claude.com/docs/en/plugins-reference#plugin-list>, accessed 2026-08-11).
   No sample output and no JSON field list is published for this command. Scope *is* documented as
   visible in the interactive `/plugin` **Installed** tab ("The list is grouped by scope"), and a
   path *is* documented for `claude plugin marketplace list --json` (`installLocation`) and for the
   `-p` `system/init` event (`plugins[].path`) — but not for `claude plugin list`. **Must be
   confirmed empirically by running the command.**

2. **The exact JSON schema of `claude plugin list --json`,** and whether `claude plugin details`
   has any machine-readable output mode. Only `-h, --help` is documented for `plugin details`.

3. **Whether `/hooks`, `/plugin`, `/skills`, or `/context` produce any output in `-p` mode.**
   The docs enumerate `-p` degradations only for `/mcp`, `/model`, `/effort`, `/fast`, `/color`,
   `/rename`, and `/config`, and state that terminal-only built-ins such as `/login` are
   unavailable. The panel commands are described as interactive but are not explicitly listed as
   `-p`-unavailable either way (<https://code.claude.com/docs/en/headless>,
   <https://code.claude.com/docs/en/commands>, accessed 2026-08-11).

4. **The literal claim "plugin hooks load at session start."** The docs say plugin hooks apply
   "When plugin is enabled" and that plugin `hooks/` changes require `/reload-plugins` or a
   restart, which implies session-start binding, but no sentence states the loading moment
   directly.

5. **Whether `claude plugin list` reflects a plugin that is installed but failed to load.**
   Load errors are documented as surfacing in the `/plugin` **Errors** tab and, for `-p`, in
   `system/init.plugin_errors`. Nothing states how `plugin list` renders a broken plugin.

6. **Whether a user-scope install from a local marketplace ever re-reads the source directory
   after install.** The docs are unambiguous that the plugin is copied to
   `~/.claude/plugins/cache` and not used in-place (§5), but they do not state what happens to the
   cached copy if the source directory is later edited *without* a version bump, beyond the general
   rule that version is the update cache key and that local development marketplaces have
   auto-update disabled by default. The two behaviours are consistent with "the cached copy keeps
   loading," but that exact sentence is not in the docs.

7. **Any official acknowledgement of GitHub issue #9354.** The docs state that
   `${CLAUDE_PLUGIN_ROOT}` resolves "anywhere the placeholder appears" in skill and agent content
   (<https://code.claude.com/docs/en/plugins-reference#environment-variables>, accessed 2026-08-11).
   Issue #9354 is open and claims the opposite for command markdown. No maintainer response, fix
   version, or changelog entry reconciling the two was found. The skills page's own substitution
   table omits `${CLAUDE_PLUGIN_ROOT}` entirely (§7.1), which neither confirms nor denies the
   plugins-reference claim.

8. **Whether the `defer` value of `permissionDecision`** (documented alongside `allow`/`deny`/`ask`)
   is usable from plugin hooks specifically, and what it does. Not investigated; noted only so the
   value is not mistaken for undocumented.

9. **Any documented CLI or non-interactive command that enumerates skills/commands or agent
   definitions across all sources** (user + project + plugin). `claude plugin details <name>` covers
   one plugin at a time; `claude agents` is the background-session view, not a definition lister;
   `/agents` prints a reminder; `/skills` and `/help` are interactive browsers. No documented
   equivalent of "list every registered skill and agent as data" exists.
