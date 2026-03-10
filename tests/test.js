/**
 * Test file for GynColors theme - JavaScript syntax.
 * Block comment: should be bright green (#00ff00)
 */

import { readFile } from "fs/promises";
import path from "path";

// Single-line comment: bright green

const MAX_RETRIES = 5;
let counter = 0;
var legacy = "old style";

// String types
const single = 'single quotes';
const double = "double quotes";
const template = `template with ${counter} interpolation`;
const escaped = "line1\nline2\ttab\\backslash";
const regex = /^hello\s+world$/gi;

// Numbers
const integer = 42;
const float = 3.14;
const hex = 0xFF;
const octal = 0o77;
const binary = 0b1010;
const bigint = 9007199254740991n;
const infinity = Infinity;
const nan = NaN;

// Language constants
const nothing = null;
const undef = undefined;
const yes = true;
const no = false;

// Operators
const sum = 10 + 20;
const ternary = sum > 25 ? "big" : "small";
const nullish = nothing ?? "default";
const optional = nothing?.property;
const spread = { ...{ a: 1 }, b: 2 };
const destructured = { a, b } = spread;

// Class with inheritance
class EventEmitter {
    #listeners = new Map();

    constructor(name) {
        this.name = name;
    }

    on(event, callback) {
        if (!this.#listeners.has(event)) {
            this.#listeners.set(event, []);
        }
        this.#listeners.get(event).push(callback);
        return this;
    }

    emit(event, ...args) {
        const handlers = this.#listeners.get(event) || [];
        for (const handler of handlers) {
            handler.apply(this, args);
        }
    }

    static create(name) {
        return new EventEmitter(name);
    }
}

class JsonEmitter extends EventEmitter {
    emit(event, data) {
        super.emit(event, JSON.stringify(data));
    }
}

// Arrow functions and async
const fetchData = async (url) => {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error("Fetch failed:", error.message);
        throw error;
    } finally {
        console.log("Request complete");
    }
};

// Generator
function* fibonacci() {
    let a = 0, b = 1;
    while (true) {
        yield a;
        [a, b] = [b, a + b];
    }
}

// Promises and array methods
const process = (items) =>
    Promise.all(
        items
            .filter((item) => item !== null)
            .map((item) => item.toString())
    );

// Switch statement
function classify(value) {
    switch (typeof value) {
        case "string":
            return "text";
        case "number":
            return "numeric";
        case "boolean":
            return "flag";
        default:
            return "unknown";
    }
}

// Symbols and iterators
const sym = Symbol("unique");
const iterable = {
    [Symbol.iterator]() {
        let i = 0;
        return {
            next: () => ({ value: i++, done: i > 5 }),
        };
    },
};

// Proxy and Reflect
const handler = {
    get(target, prop, receiver) {
        return Reflect.get(target, prop, receiver);
    },
    set(target, prop, value) {
        if (typeof value !== "number") {
            throw new TypeError("Expected number");
        }
        return Reflect.set(target, prop, value);
    },
};

export { EventEmitter, fetchData, fibonacci, classify };
export default process;
