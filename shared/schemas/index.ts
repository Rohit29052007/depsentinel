import { z } from 'zod';

export const DependencySchema = z.object({
    name: z.string(),
    version: z.string(),
    type: z.enum(['direct', 'transitive']),
    ecosystem: z.enum(['npm', 'pip', 'maven', 'go', 'cargo', 'docker']),
});

export const VulnerabilitySchema = z.object({
    id: z.string(),
    severity: z.enum(['low', 'medium', 'high', 'critical']),
    package: z.string(),
    affectedVersions: z.array(z.string()),
    fixedVersion: z.string().optional(),
    description: z.string(),
});

export const PredictionSchema = z.object({
    dependency: z.string(),
    currentVersion: z.string(),
    targetVersion: z.string(),
    breakingChangeProbability: z.number().min(0).max(1),
    affectedFiles: z.array(z.string()),
    suggestedFixes: z.array(z.string()),
});
