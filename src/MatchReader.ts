import { dateStringToDate } from "./utils";
import { MatchResult } from "./MatchResult";

export type MatchData = [Date, string, string, number, number, MatchResult, string];

interface DataReader {
    read(): void;
    data: string[][];
}

export class MatchReader {
    public reader: DataReader;
    constructor(reader: DataReader) {
        this.reader = reader;
    }
}
