// CI guard: fails unless manifest.json's version is a strict semver bump over
// a base ref, e.g. `node checkManifest.mjs origin/master`.
import { readFileSync } from "node:fs"
import { execFileSync } from "node:child_process"

const ref = process.argv[2] || "origin/master"

function versionOf(manifest) {
  const v = String(manifest.version || "").trim()
  const m = /^(\d+)\.(\d+)\.(\d+)$/.exec(v)
  if (!m)
    throw new Error(`manifest.json has no plain x.y.z version: "${v}"`)
  return [Number(m[1]), Number(m[2]), Number(m[3])]
}

function show(ref, path) {
  return execFileSync("git", ["show", `${ref}:${path}`], { encoding: "utf8" })
}

const current = versionOf(JSON.parse(readFileSync("manifest.json", "utf8")))
let base
try {
  base = versionOf(JSON.parse(show(ref, "manifest.json")))
} catch (e) {
  console.error(`could not read manifest.json from ${ref}: ${e.message}`)
  process.exit(1)
}

const diff = current.map((n, i) => n - base[i])
const first = diff.find((d) => d !== 0) || 0
if (first <= 0) {
  console.error(`manifest.json version not bumped: ${current.join(".")} must be greater than ${base.join(".")} (${ref})`)
  process.exit(1)
}
console.log(`manifest.json version ok: ${base.join(".")} -> ${current.join(".")}`)
