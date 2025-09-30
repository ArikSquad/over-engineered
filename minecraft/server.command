#!/bin/bash
cd "$(dirname "$0")"

PREFIX=${PREFIX:-paper}
MIN=${MIN:-1G}
MAX=${MAX:-4G}
JVM_OPTS=${JVM_OPTS:-}

jar=$(ls -1t *"$PREFIX"*.jar 2>/dev/null | head -n1 || true)
if [[ -z "${jar}" ]]; then
  osascript -e 'display alert "No server JAR found" message "Place a *$PREFIX*.jar here or set PREFIX"'
  exit 1
fi

echo "Launching: java -Xmx${MAX} -Xms${MIN} ${JVM_OPTS} -jar ${jar}"
exec java -Xmx"${MAX}" -Xms"${MIN}" ${JVM_OPTS} -jar "${jar}"
