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

# ssh-add asks for the passphrase even when the agent already holds the key, so
# only add it when the agent lacks it. Key material is still created manually.
set -l __key ~/.ssh/on3iropolos-ssh
set -l __fingerprint (command ssh-keygen -lf "$__key.pub" 2>/dev/null | string match -r 'SHA256:[^ ]+')
if test -z "$__fingerprint"; or not command ssh-add -l 2>/dev/null | string match -q -- "*$__fingerprint*"
    command ssh-add -- "$__key" 2>/dev/null
end
