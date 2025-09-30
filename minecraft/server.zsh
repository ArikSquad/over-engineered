#!/usr/bin/env zsh
set -euo pipefail

cd "${0:A:h}"

typeset -g PREFIX=${PREFIX:-paper}
typeset -g MIN=${MIN:-1G}
typeset -g MAX=${MAX:-4G}
typeset -g JVM_OPTS=${JVM_OPTS:-}

local jar
jar=$(ls -1t *"$PREFIX"*.jar 2>/dev/null | head -n1 || true)
if [[ -z "$jar" ]]; then
  print -u2 "Error: no JAR found matching *${PREFIX}*.jar in $PWD"
  exit 1
fi

print "Launching: java -Xmx${MAX} -Xms${MIN} ${JVM_OPTS} -jar ${jar}"
exec java -Xmx"${MAX}" -Xms"${MIN}" ${JVM_OPTS} -jar "$jar"
