import "common.just"

vrt_home := home_dir() + "/.vrt"
vrt_screenshot := vrt_home / "screenshot"
vrt_lock := vrt_home / ".lock"
vrt_urls := vrt_home / "urls.txt"
vrt_report := vrt_home / "report.html"

# Display this list of available commands
@list:
    just --justfile "{{ source_file() }}" --list

# Start a VRT session and capture screenshots of what the site is expected to look like
@capture host: _ensure_unlocked _ensure_dependencies _lock _get_pages (_capture host "expected")

# Capture and compare screenshots against the original screenshots captured in this session
@compare host: _ensure_locked _ensure_dependencies (_capture host "actual")
    npx reg-cli "{{ vrt_screenshot }}/actual" "{{ vrt_screenshot }}/expected" "{{ vrt_screenshot }}/diff" -A -M 0.4 --report "{{ vrt_report }}" --json /dev/null; open "{{ vrt_report }}"

# Complete and clean up a VRT session
@complete:
    -rm "{{ vrt_screenshot }}"/*/* 2>/dev/null
    -rm "{{ vrt_urls }}" 2>/dev/null
    -rm "{{ vrt_report }}" 2>/dev/null
    -rm "{{ vrt_lock }}" 2>/dev/null

@_ensure_dependencies:
    if ! npm list -g --depth 1 puppeteer > /dev/null; then npm install -g puppeteer; fi
    if ! npm list -g --depth 1 mkdirp > /dev/null; then npm install -g mkdirp; fi
    if ! npm list -g --depth 1 slug > /dev/null; then npm install -g slug; fi
    if ! npm list -g --depth 1 reg-cli > /dev/null; then npm install -g reg-cli; fi
    mkdir -p "{{ vrt_home }}/screenshot/"{actual,diff,expected}

[no-exit-message]
@_ensure_unlocked:
    if [[ -f "{{ vrt_lock }}" ]]; then \
        echo "{{ error }} A visual regression testing session is already in progress."; \
        echo "Use 'gust vrt::complete' to end the existing session."; \
        exit 1; \
    fi

[no-exit-message]
@_ensure_locked:
    if [[ ! -f "{{ vrt_lock }}" ]]; then \
        echo "{{ error }} A visual regression testing session has not been started yet."; \
        echo "Use 'gust vrt::capture' to start a session."; \
        exit 1; \
    fi

@_lock:
    touch "{{ vrt_lock }}"

@_get_pages:
    echo "# Add paths to test to this file, one per line. Paths should start with a /. This line will automatically be removed." > "{{ vrt_urls }}"
    $EDITOR "{{ vrt_urls }}"
    awk -F\# '$1 != "" { print $1 } ' "{{ vrt_urls }}" > "{{ vrt_urls }}.tmp" \
        && mv -f "{{ vrt_urls }}.tmp" "{{ vrt_urls }}"

export NODE_PATH := `npm root -g`

_capture host destination width="1150" height="1200": _ensure_dependencies
    #!/usr/bin/env node
    const fs = require("fs")
    const puppeteer = require("puppeteer");
    const mkdirp = require("mkdirp");
    const slugger = require("slug");

    let host = "{{ host }}";
    let destination = "{{ destination }}";
    let pages = fs.readFileSync('{{ vrt_urls }}').toString().split("\n");

    async function main() {
      const browser = await puppeteer.launch({ args: ["--no-sandbox", "--disable-setuid-sandbox"] });
      let page = await browser.newPage();

      await page.setViewport({ width: {{ width }}, height: {{ height }} });
        for (const path of pages) {
            if (!path) continue;
            const slug = path === "/" ? "index" : slugger(path);
            const url = `${host}${path}`;
            // console.log(`Capturing ${url} -> ${slug}.png`);
            await page.goto(url);
            await new Promise(res => setTimeout(() => res(), 500));
            await page.screenshot({ path: `{{ vrt_home }}/screenshot/${destination}/${slug}.png` });
        }

      await page.close();
      await browser.close();
    }

    mkdirp.sync("{{ vrt_home }}/screenshot");
    main();
