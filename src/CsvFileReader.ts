import fs from 'fs';

export class CsvFileReader {
    data: string[][] = [];
    public filename: string;
    
    constructor(filename: string) {
        this.filename = filename;
    }

    read(): void {
        this.data = fs.
        readFileSync(this.filename, {encoding: 'utf-8'})
        .split('\n')
        .map((row: string): string[] => {
            return row.split(',')
        });
    }
}
