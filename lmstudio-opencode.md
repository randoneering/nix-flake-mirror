# LM Studio and opencode

Use `lms` to start the local LM Studio server and load models with stable identifiers. `opencode` then refers to those identifiers with the `lmstudio/` provider prefix.

## List Models

```bash
lms ls
```

Current local model keys:

- `google/gemma-4-e4b`
- `qwen/qwen3.5-9b`

## Start Server

```bash
lms server start
```

## Load qwen3.5-9b

Use this for larger coding tasks, debugging, planning, and multi-file work.

```bash
lms load qwen/qwen3.5-9b \
  --identifier qwen3.5-9b \
  --gpu max \
  --context-length 32768 \
  --ttl 3600
```

If the model is already loaded with the wrong identifier, reload it:

```bash
lms unload qwen/qwen3.5-9b
lms load qwen/qwen3.5-9b \
  --identifier qwen3.5-9b \
  --gpu max \
  --context-length 32768 \
  --ttl 3600
```

## Load gemma-4-e4b

Use this for lower-latency tasks and lighter resource use.

```bash
lms load google/gemma-4-e4b \
  --identifier gemma-4-e4b \
  --gpu max \
  --context-length 16384 \
  --ttl 3600
```

LM Studio reports two local variants for `google/gemma-4-e4b`. If `lms load` prompts for a variant, choose the smaller/faster quant for speed or the larger quant for quality.

## Check Loaded Models

```bash
lms ps
```

Expected API identifiers:

- `gemma-4-e4b`
- `qwen3.5-9b`

## opencode Model Names

Use these names in `opencode`:

```text
lmstudio/gemma-4-e4b
lmstudio/qwen3.5-9b
```

## Request Settings

LM Studio CLI can set load-time options such as context length, GPU offload, and TTL. Generation settings such as temperature, top-p, top-k, repeat penalty, and max output tokens are usually controlled by the client request or LM Studio presets.

Suggested coding defaults:

| Setting | Value |
| --- | --- |
| Temperature | `0.2` |
| Top P | `0.9` |
| Top K | `40` |
| Repeat penalty | `1.05` |
| Max output tokens | `4096` |

## Memory Estimate

Before loading a model with a large context window, estimate memory use:

```bash
lms load --estimate-only qwen/qwen3.5-9b --gpu max --context-length 32768
lms load --estimate-only google/gemma-4-e4b --gpu max --context-length 16384
```
