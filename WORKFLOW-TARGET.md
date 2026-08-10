# WORKFLOW-TARGET

> Nota (pt-BR): este arquivo guarda, palavra por palavra, o fluxo de trabalho alvo do plugin my-method; as sessões da auditoria (separadas por /clear) leem este arquivo em vez da conversa original, que não sobrevive.

Persisted verbatim from the audit brief, session 1 of 4, 2026-08-10. This is the target behaviour the plugin must guarantee. Do not edit the sections below; they are the reference every audit session evaluates against.

=== THE WORKFLOW I WANT — this is the target behaviour ===

A. STARTING A NEW PROJECT
1. I create an empty folder and open Claude Code inside it.
2. I type /my-method:start-project.
3. I describe my initial idea in one or two sentences.
4. You interrogate me relentlessly, ONE question at a time, in Portuguese, each question carrying your own recommendation embedded so I can simply agree when I have no opinion. You continue until no decision is left open — cover at minimum: who uses it, whether it stores other people's personal data, whether it needs login, whether it must be online, what language the end users read, what "finished" means for this project, and anything else the idea implies.
5. From the interrogation you write a SPEC describing BEHAVIOUR, not technology, and summarize it to me in Portuguese. YOU STOP AND WAIT. This is a mandatory gate. If I do not approve, you interrogate me again to find out what I want changed, removed, or added, rewrite the spec, and wait again.
6. From the approved spec, YOU decide the stack yourself. Present the decision already made, with plain-language reasoning in Portuguese and what the runner-up would have cost me. Record the reason in STATE.md, not just the name.
7. You write a PLAN of tasks in chronological order. Every task must be small enough to fit in ONE session without filling the context window — because a full context degrades output quality silently, and that is a failure mode I cannot detect on my own. Any task that does not fit gets split NOW, at planning time. Ask me ONE question and only this one: "você reconhece o seu produto nesta lista?" I am not approving technical sequencing — I have no basis for that.
8. You create STATE.md and the project CLAUDE.md, initialize git, make the first commit, and then tell me to run /clear.

B. EVERY SUBSEQUENT SESSION
9. Fresh session, I type /my-method:next-task.
10. At the START of the task, you recommend the model and effort level to use for it, and ask me to set it before you begin. One interruption, at the beginning, never mid-task.
11. You execute the task, narrating intent and consequence in Portuguese, never mechanics.
12. At the END of every task, verification runs before the task can be called done: functional tests, regression (everything that already existed, not just the new check), and the security checks the task's risk surfaces require per playbook/SECURITY-MATRIX.md. Raw output shown on my screen — not your sentence saying it passed. If any check fails, the task is NOT complete and you do not commit.
13. You update STATE.md, PLAN.md and the task card together, commit, and tell me to run /clear.
14. I run /clear. Back to step 9. This repeats until the project is finished.

C. WHAT NEVER CHANGES
Whatever the project, I only ever type: /my-method:start-project once, then /my-method:next-task repeatedly. Everything else is you.

=== VERDICT SCALE — verbatim from the same audit brief ===

For each step, state exactly one of:
  GUARANTEED — and say by which mechanism.
  PARTIAL — and say what is missing.
  ABSENT — the plugin does not do this at all.

=== ENFORCEMENT LEVELS — verbatim from the same audit brief ===

  Level 1 DETERMINISTIC (hooks, permissions): runs regardless of your judgment. Strongest, costs setup.
  Level 2 STRUCTURAL (the command is the only entry point): I cannot skip a step I never type.
  Level 3 INSTRUCTIONAL (CLAUDE.md, command bodies, skill bodies): followed almost always — weakest exactly when sessions get long.
  Level 4 EVIDENTIAL (machine-verifiable done, one commit per task): does not prevent failure, makes it visible after.

For each step, recommend the cheapest level that is good enough, state its cost, and say plainly what breaks one level lower.
