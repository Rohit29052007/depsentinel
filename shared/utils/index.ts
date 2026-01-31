export function formatVersion(version: string): string {
    return version.replace(/^[^0-9]+/, '');
}

export function compareVersions(v1: string, v2: string): number {
    const parts1 = formatVersion(v1).split('.').map(Number);
    const parts2 = formatVersion(v2).split('.').map(Number);

    for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
        const part1 = parts1[i] || 0;
        const part2 = parts2[i] || 0;

        if (part1 > part2) return 1;
        if (part1 < part2) return -1;
    }

    return 0;
}

export function isBreakingChange(oldVersion: string, newVersion: string): boolean {
    const oldMajor = parseInt(formatVersion(oldVersion).split('.')[0]);
    const newMajor = parseInt(formatVersion(newVersion).split('.')[0]);
    return newMajor > oldMajor;
}
