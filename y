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


async delete(id: number): Promise<DispositionSupport> {
    this.logger.log(`Somebody asked to delete disposition support id ${id}`);

    // Find the disposition support entry by ID
    const dispositionSupport: DispositionSupport = await this.findOneOrDie(id);

    // Set isDeleted to true
    dispositionSupport.isDeleted = true;

    // Save the updated record
    return this.dispositionSupportRepository.save(dispositionSupport);
}
