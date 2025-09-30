#!/usr/bin/env fish
set -e

cd (dirname (status --current-filename))

set -q PREFIX; or set PREFIX paper
set -q MIN; or set MIN 1G
set -q MAX; or set MAX 4G
set -q JVM_OPTS; or set JVM_OPTS ""

set jar (ls -1t *$PREFIX*.jar ^/dev/null | head -n1)
if test -z "$jar"
  echo "Error: no JAR found matching *$PREFIX*.jar in (pwd)" >&2
  exit 1
end

echo "Launching: java -Xmx$MAX -Xms$MIN $JVM_OPTS -jar $jar"
exec java -Xmx"$MAX" -Xms"$MIN" $JVM_OPTS -jar "$jar"
