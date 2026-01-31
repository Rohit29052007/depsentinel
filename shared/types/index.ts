export interface DependencyInfo {
    name: string;
    version: string;
    type: 'direct' | 'transitive';
    ecosystem: 'npm' | 'pip' | 'maven' | 'go' | 'cargo' | 'docker';
}

export interface VulnerabilityInfo {
    id: string;
    severity: 'low' | 'medium' | 'high' | 'critical';
    package: string;
    affectedVersions: string[];
    fixedVersion?: string;
    description: string;
}

export interface PredictionResult {
    dependency: string;
    currentVersion: string;
    targetVersion: string;
    breakingChangeProbability: number;
    affectedFiles: string[];
    suggestedFixes: string[];
}
