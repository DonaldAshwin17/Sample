import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class AddIsDeletedToDispositionSupport implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.addColumn("disposition_support", new TableColumn({
            name: "isDeleted",
            type: "boolean",
            default: false,
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropColumn("disposition_support", "isDeleted");
    }
}
npx typeorm migration:generate -n AddIsDeletedToDispositionSupport
npx typeorm migration:run
