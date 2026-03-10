// Test file for GynColors theme - TypeScript syntax.

import { EventEmitter } from "events";
import type { IncomingMessage, ServerResponse } from "http";

// Enum
enum Direction {
    Up = "UP",
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
}

const enum HttpStatus {
    OK = 200,
    NotFound = 404,
    ServerError = 500,
}

// Interface
interface User {
    readonly id: number;
    name: string;
    email: string;
    age?: number;
    roles: string[];
    metadata: Record<string, unknown>;
}

interface Repository<T> {
    findById(id: number): Promise<T | null>;
    findAll(): Promise<T[]>;
    create(item: Omit<T, "id">): Promise<T>;
    update(id: number, item: Partial<T>): Promise<T>;
    delete(id: number): Promise<boolean>;
}

// Type aliases
type Nullable<T> = T | null;
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };
type EventHandler<T = void> = (event: T) => void | Promise<void>;

// Decorator (experimental)
function log(target: unknown, key: string, descriptor: PropertyDescriptor) {
    const original = descriptor.value;
    descriptor.value = function (...args: unknown[]) {
        console.log(`Calling ${key} with`, args);
        return original.apply(this, args);
    };
    return descriptor;
}

// Generic class
class UserRepository implements Repository<User> {
    private users: Map<number, User> = new Map();
    private nextId = 1;

    async findById(id: number): Promise<User | null> {
        return this.users.get(id) ?? null;
    }

    async findAll(): Promise<User[]> {
        return Array.from(this.users.values());
    }

    @log
    async create(data: Omit<User, "id">): Promise<User> {
        const user: User = { ...data, id: this.nextId++ };
        this.users.set(user.id, user);
        return user;
    }

    async update(id: number, data: Partial<User>): Promise<User> {
        const existing = this.users.get(id);
        if (!existing) {
            throw new Error(`User ${id} not found`);
        }
        const updated = { ...existing, ...data };
        this.users.set(id, updated);
        return updated;
    }

    async delete(id: number): Promise<boolean> {
        return this.users.delete(id);
    }
}

// Utility types and generics
function pick<T, K extends keyof T>(obj: T, keys: K[]): Pick<T, K> {
    const result = {} as Pick<T, K>;
    for (const key of keys) {
        result[key] = obj[key];
    }
    return result;
}

function assertNonNull<T>(value: T | null | undefined, msg?: string): asserts value is T {
    if (value == null) {
        throw new Error(msg ?? "Value is null");
    }
}

// Discriminated union
type Shape =
    | { kind: "circle"; radius: number }
    | { kind: "rectangle"; width: number; height: number }
    | { kind: "triangle"; base: number; height: number };

function area(shape: Shape): number {
    switch (shape.kind) {
        case "circle":
            return Math.PI * shape.radius ** 2;
        case "rectangle":
            return shape.width * shape.height;
        case "triangle":
            return (shape.base * shape.height) / 2;
    }
}

// Template literal types
type HttpMethod = "GET" | "POST" | "PUT" | "DELETE";
type ApiRoute = `/api/${string}`;
type Endpoint = `${HttpMethod} ${ApiRoute}`;

// Conditional types
type IsString<T> = T extends string ? true : false;
type Flatten<T> = T extends Array<infer U> ? U : T;

// Mapped types
type Readonly2<T> = {
    readonly [P in keyof T]: T[P];
};

type Optional<T> = {
    [P in keyof T]?: T[P];
};

// Async generators
async function* paginate<T>(
    fetcher: (page: number) => Promise<T[]>,
    maxPages: number = 10,
): AsyncGenerator<T[], void, unknown> {
    for (let page = 1; page <= maxPages; page++) {
        const items = await fetcher(page);
        if (items.length === 0) break;
        yield items;
    }
}

// String literals and template
const greeting: string = "Hello, World!";
const escaped: string = "line1\nline2\ttab\\backslash";
const template: string = `Value: ${42}, Bool: ${true}, Expr: ${2 + 2}`;
const regex: RegExp = /^[a-z]+\d{2,4}$/gi;

// Numeric literals
const integer: number = 42;
const float: number = 3.14;
const hex: number = 0xff;
const octal: number = 0o77;
const binary: number = 0b1010;
const bigint: bigint = 9007199254740991n;
const separator: number = 1_000_000;

// Null handling
const value: string | null = null;
const fallback = value ?? "default";
const length = value?.length;

// Main
async function main(): Promise<void> {
    const repo = new UserRepository();

    const user = await repo.create({
        name: "Alice",
        email: "alice@example.com",
        roles: ["admin"],
        metadata: { source: "api" },
    });

    console.log("Created:", user);

    const found = await repo.findById(user.id);
    assertNonNull(found);
    console.log("Found:", pick(found, ["id", "name", "email"]));

    const circle: Shape = { kind: "circle", radius: 5 };
    console.log(`Area: ${area(circle).toFixed(2)}`);
}

main().catch(console.error);
