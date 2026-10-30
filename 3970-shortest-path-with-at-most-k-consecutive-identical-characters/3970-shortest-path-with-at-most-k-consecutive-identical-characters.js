/*
Brute Force

var shortestPath = function(n, edges, labels, k) {
    const dist = new Float64Array(n * (k + 1)).fill(Infinity);
    dist[1] = 0;
    let changed = true;
    while (changed) {
        changed = false;
        for (const [u, v, w] of edges) {
            for (let run = 1; run <= k; run++) {
                const d = dist[u * (k + 1) + run];
                if (d === Infinity) continue;
                const next = labels[v] === labels[u] ? run + 1 : 1;
                if (next <= k && d + w < dist[v * (k + 1) + next]) {
                    dist[v * (k + 1) + next] = d + w;
                    changed = true;
                }
            }
        }
    }
    let ans = Infinity;
    for (let run = 1; run <= k; run++) ans = Math.min(ans, dist[(n - 1) * (k + 1) + run]);
    return ans === Infinity ? -1 : ans;
};
*/

/*
Better Approach

var shortestPath = function(n, edges, labels, k) {
    const g = Array.from({ length: n }, () => []);
    for (const [u, v, w] of edges) g[u].push([v, w]);
    const dist = new Float64Array(n * (k + 1)).fill(Infinity);
    const heap = [];
    const push = (item) => {
        heap.push(item);
        let i = heap.length - 1;
        while (i > 0) {
            const p = (i - 1) >> 1;
            if (heap[p][0] <= item[0]) break;
            heap[i] = heap[p];
            i = p;
        }
        heap[i] = item;
    };
    const pop = () => {
        const top = heap[0];
        const last = heap.pop();
        if (heap.length) {
            let i = 0;
            while (2 * i + 1 < heap.length) {
                let c = 2 * i + 1;
                if (c + 1 < heap.length && heap[c + 1][0] < heap[c][0]) c++;
                if (heap[c][0] >= last[0]) break;
                heap[i] = heap[c];
                i = c;
            }
            heap[i] = last;
        }
        return top;
    };
    dist[1] = 0;
    push([0, 0, 1]);
    while (heap.length) {
        const [d, u, run] = pop();
        if (u === n - 1) return d;
        if (d > dist[u * (k + 1) + run]) continue;
        for (const [v, w] of g[u]) {
            const next = labels[v] === labels[u] ? run + 1 : 1;
            if (next <= k && d + w < dist[v * (k + 1) + next]) {
                dist[v * (k + 1) + next] = d + w;
                push([d + w, v, next]);
            }
        }
    }
    return -1;
};
*/

var shortestPath = function(n, edges, labels, k) {
    const g = Array.from({ length: n }, () => []);
    for (const [u, v, w] of edges) g[u].push([v, w]);
    const best = new Int32Array(n).fill(k + 1);
    const heap = [];
    const push = (item) => {
        heap.push(item);
        let i = heap.length - 1;
        while (i > 0) {
            const p = (i - 1) >> 1;
            if (heap[p][0] <= item[0]) break;
            heap[i] = heap[p];
            i = p;
        }
        heap[i] = item;
    };
    const pop = () => {
        const top = heap[0];
        const last = heap.pop();
        if (heap.length) {
            let i = 0;
            while (2 * i + 1 < heap.length) {
                let c = 2 * i + 1;
                if (c + 1 < heap.length && heap[c + 1][0] < heap[c][0]) c++;
                if (heap[c][0] >= last[0]) break;
                heap[i] = heap[c];
                i = c;
            }
            heap[i] = last;
        }
        return top;
    };
    push([0, 0, 1]);
    while (heap.length) {
        const [d, u, run] = pop();
        if (run >= best[u]) continue;
        if (u === n - 1) return d;
        best[u] = run;
        for (const [v, w] of g[u]) {
            const next = labels[v] === labels[u] ? run + 1 : 1;
            if (next <= k && next < best[v]) push([d + w, v, next]);
        }
    }
    return -1;
};