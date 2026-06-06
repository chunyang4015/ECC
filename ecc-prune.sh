#!/bin/bash
# ECC Plugin Prune Script
# Generated for user's tech stack: Java/Spring, Python, TS/React, Android/Kotlin, Next.js/Node
# Review before running!

ECC_ROOT="$HOME/.claude/plugins/marketplaces/ecc"
RULES_ROOT="$HOME/.claude/rules/ecc"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

deleted=0
kept=0
errors=0

delete_item() {
    local path="$1"
    local type="$2"
    local name="$3"

    if [ -e "$path" ]; then
        rm -rf "$path"
        echo -e "  ${RED}✗${NC} Deleted $type: $name"
        ((deleted++))
    else
        echo -e "  ${YELLOW}?${NC} Not found: $name"
        ((errors++))
    fi
}

echo "========================================="
echo "  ECC Plugin Prune Script"
echo "========================================="
echo ""

# ==========================================
# 1. AGENTS - Delete 19
# ==========================================
echo -e "${GREEN}>>> Pruning Agents (delete 19)${NC}"

AGENT_DELETES=(
    "chief-of-staff"
    "code-architect"
    "comment-analyzer"
    "conversation-analyzer"
    "dart-build-resolver"
    "flutter-reviewer"
    "harmonyos-app-resolver"
    "harness-optimizer"
    "healthcare-reviewer"
    "homelab-architect"
    "marketing-agent"
    "opensource-forker"
    "opensource-packager"
    "opensource-sanitizer"
    "pr-test-analyzer"
    "seo-specialist"
    "swift-build-resolver"
    "swift-reviewer"
    "type-design-analyzer"
)

for agent in "${AGENT_DELETES[@]}"; do
    delete_item "$ECC_ROOT/agents/${agent}.md" "agent" "$agent"
done

echo ""

# ==========================================
# 2. SKILLS - Delete 40
# ==========================================
echo -e "${GREEN}>>> Pruning Skills (delete 40)${NC}"

SKILL_DELETES=(
    # Not in tech stack
    "bun-runtime"
    "dart-flutter-patterns"
    "flutter-dart-code-review"
    "kotlin-exposed-patterns"
    "kotlin-ktor-patterns"
    "prisma-patterns"
    "quarkus-patterns"
    "quarkus-security"
    "quarkus-tdd"
    "quarkus-verification"
    "swift-actor-persistence"
    "swift-concurrency-6-2"
    "swift-protocol-di-testing"
    "swiftui-patterns"
    # AI/Agent meta - not kept
    "agent-architecture-audit"
    "agent-payment-x402"
    "agent-sort"
    "agentic-engineering"
    "agentic-os"
    "ai-first-engineering"
    "autonomous-loops"
    "claude-devfleet"
    "continuous-learning"
    "continuous-learning-v2"
    "eval-harness"
    # Marketing - not kept
    "seo"
    "social-graph-ranker"
    "social-publisher"
    # Overly specialized - user confirmed delete
    "code-tour"
    "council"
    "crosspost"
    "dashboard-builder"
    "dmux-workflows"
    "gateguard"
    "hexagonal-architecture"
    "ios-icon-gen"
    "opensource-pipeline"
    "parallel-execution-optimizer"
    "recursive-decision-ledger"
    "token-budget-advisor"
)

for skill in "${SKILL_DELETES[@]}"; do
    delete_item "$ECC_ROOT/skills/${skill}" "skill" "$skill"
done

echo ""

# ==========================================
# 3. COMMANDS - Delete 43
# ==========================================
echo -e "${GREEN}>>> Pruning Commands (delete 43)${NC}"

COMMAND_DELETES=(
    "aside"
    "auto-update"
    "checkpoint"
    "cost-report"
    "evolve"
    "flutter-build"
    "flutter-review"
    "flutter-test"
    "harness-audit"
    "hookify"
    "hookify-configure"
    "hookify-help"
    "hookify-list"
    "instinct-export"
    "instinct-import"
    "instinct-status"
    "jira"
    "learn"
    "learn-eval"
    "loop-start"
    "loop-status"
    "marketing-campaign"
    "model-route"
    "multi-backend"
    "multi-execute"
    "multi-frontend"
    "multi-plan"
    "multi-workflow"
    "pm2"
    "promote"
    "prp-commit"
    "prp-implement"
    "prp-plan"
    "prp-pr"
    "prp-prd"
    "prune"
    "resume-session"
    "santa-loop"
    "save-session"
    "sessions"
    "setup-pm"
    "skill-create"
    "skill-health"
)

for cmd in "${COMMAND_DELETES[@]}"; do
    delete_item "$ECC_ROOT/commands/${cmd}.md" "command" "$cmd"
done

echo ""

# ==========================================
# 4. RULES - Delete 2 directories
# ==========================================
echo -e "${GREEN}>>> Pruning Rules (delete dart/ and swift/)${NC}"

delete_item "$RULES_ROOT/dart" "rules dir" "dart"
delete_item "$RULES_ROOT/swift" "rules dir" "swift"

echo ""

# ==========================================
# 5. MCP Servers - Remove 18 from JSON config
# ==========================================
echo -e "${GREEN}>>> Pruning MCP Servers (delete 18, keep 11)${NC}"

MCP_CONFIG="$ECC_ROOT/mcp-configs/mcp-servers.json"

if [ -f "$MCP_CONFIG" ]; then
    python3 << 'PYEOF'
import json

MCP_DELETES = [
    'jira', 'firecrawl', 'supabase', 'omega-memory', 'longhand',
    'vercel', 'railway', 'clickhouse', 'magic', 'fal-ai',
    'browserbase', 'browser-use', 'devfleet', 'token-optimizer',
    'laraplugins', 'confluence', 'evalview', 'squish'
]

config_path = None
import os
for candidate in [
    os.path.expanduser('~/.claude/plugins/marketplaces/ecc/mcp-configs/mcp-servers.json')
]:
    if os.path.exists(candidate):
        config_path = candidate
        break

if not config_path:
    print('  ? MCP config not found')
else:
    with open(config_path, 'r') as f:
        config = json.load(f)

    servers = config.get('mcpServers', {})
    before = len(servers)

    for name in MCP_DELETES:
        if name in servers:
            del servers[name]
            print(f'  \033[0;31m✗\033[0m Removed MCP server: {name}')

    after = len(servers)
    print(f'  Kept {after} servers (removed {before - after})')

    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')
PYEOF
else
    echo -e "  ${YELLOW}?${NC} MCP config not found at $MCP_CONFIG"
fi

echo ""

# ==========================================
# Summary
# ==========================================
echo "========================================="
echo -e "  Prune complete!"
echo -e "  Deleted: ${RED}${deleted}${NC} items"
echo -e "  Not found: ${YELLOW}${errors}${NC} items"
echo "========================================="
