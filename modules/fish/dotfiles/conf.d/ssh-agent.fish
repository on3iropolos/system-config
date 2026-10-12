# ssh-agent bootstrap.
#
# fish cannot use `eval` during startup, so the agent output is captured with
# `string match` instead. A socket left behind by a killed agent is treated as
# missing so the agent is restarted rather than inherited dead.

if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
    set -l __agent_out (command ssh-agent)
    set -gx SSH_AUTH_SOCK (string match -r 'SSH_AUTH_SOCK=([^;]+)' -- $__agent_out)[2]
    set -gx SSH_AGENT_PID (string match -r 'SSH_AGENT_PID=([0-9]+)' -- $__agent_out)[2]
end

# Key material is created manually; silence the prompt in non-interactive
# shells so scp, editors and cron do not hang on a passphrase.
command ssh-add -- ~/.ssh/on3iropolos-ssh 2>/dev/null