#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PREFIX=${PREFIX:-paper}
MIN=${MIN:-1G}
MAX=${MAX:-4G}
# Extra JVM args (optional), e.g. JVM_OPTS="-XX:+UseG1GC"
JVM_OPTS=${JVM_OPTS:-}

jar=$(ls -1t *"$PREFIX"*.jar 2>/dev/null | head -n1 || true)
if [[ -z "${jar}" ]]; then
  echo "Error: no JAR found matching *${PREFIX}*.jar in $(pwd)" >&2
  echo "Tip: set PREFIX=<pattern> or place your Paper server jar here." >&2
  exit 1
fi

echo "Launching: java -Xmx${MAX} -Xms${MIN} ${JVM_OPTS} -jar ${jar}"
exec java -Xmx"${MAX}" -Xms"${MIN}" ${JVM_OPTS} -jar "${jar}"
