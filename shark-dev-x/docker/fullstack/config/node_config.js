/**
 * 🌍 Node Config
 * Unified configuration for backend/frontend apps
 */
import dotenv from "dotenv";
import path from "path";
import process from "process";

const envPath = path.resolve("/env/.env");
dotenv.config({ path: envPath });

export const config = {
  appName: process.env.APP_NAME || "FullstackApp",
  env: process.env.NODE_ENV || "development",
  debug: process.env.DEBUG === "true",

  db: {
    user: process.env.DB_USER || "user",
    pass: process.env.DB_PASS || "password",
    host: process.env.DB_HOST || "localhost",
    port: process.env.DB_PORT || "5432",
    name: process.env.DB_NAME || "appdb",
  },

  redisUrl: process.env.REDIS_URL || "redis://localhost:6379/0",
  apiPrefix: process.env.API_PREFIX || "/api/v1",
  port: parseInt(process.env.PORT || "3000", 10),
};
