// deno-lint-ignore-file no-explicit-any
export type PurgeResult = {
    ok: boolean;
    items: Array<{
        entity: string;
        table: string;
        ttl_days: number;
        dry_run: boolean;
        affected: number;
    }>;
};

export async function purgeExpiredData(client: any, dryRun = true): Promise<PurgeResult> {
    const { data, error } = await client.rpc('purge_expired_data', { dry_run: dryRun });
    if (error) throw error;
    return data as PurgeResult;
}



