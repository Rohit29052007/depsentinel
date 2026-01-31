export const config = {
    api: {
        port: process.env.PORT || 3000,
        baseUrl: process.env.API_BASE_URL || 'http://localhost:3000',
    },
    database: {
        url: process.env.DATABASE_URL || 'postgresql://depsentinel:depsentinel_dev@localhost:5432/depsentinel',
    },
    redis: {
        url: process.env.REDIS_URL || 'redis://localhost:6379',
    },
};
