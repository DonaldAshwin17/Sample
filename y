import { MigrationInterface, QueryRunner } from "typeorm";

export class AddIsDeletedToDispositionSupport implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE "disposition_support"
            ADD COLUMN "isDeleted" BOOLEAN DEFAULT FALSE;
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE "disposition_support"
            DROP COLUMN "isDeleted";
        `);
    }
}
