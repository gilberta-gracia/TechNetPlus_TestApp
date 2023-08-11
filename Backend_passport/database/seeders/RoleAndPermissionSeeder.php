<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class RoleAndPermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Permission::create(['name' => 'create-users']);
        Permission::create(['name' => 'edit-users']);
        Permission::create(['name' => 'delete-users']);
        Permission::create(['name' => 'read-users']);

        Permission::create(['name' => 'read-employes']);
        Permission::create(['name' => 'create-employes']);
        Permission::create(['name' => 'delete-employes']);
        Permission::create(['name' => 'edit-employes']);       
        Permission::create(['name' => 'edit-employes-poste']);
        Permission::create(['name' => 'edit-employes-salaire']);

        $userRole = Role::create(['name' => 'Aucun']);
        $adminRole = Role::create(['name' => 'Admin']);
        $humanRole = Role::create(['name' => 'RH']);
        $moneyRole = Role::create(['name' => 'Comptable']);

        $userRole ->givePermissionTo(['read-employes']);

        $adminRole->givePermissionTo([
            'create-users',
            'edit-users',
            'delete-users',
            'read-users',
            'read-employes',
            'create-employes',
            'delete-employes',
            'edit-employes'
        ]);

        $humanRole->givePermissionTo([
            'read-employes',
            'create-employes',
            'delete-employes',
            'edit-employes-poste'
        ]);

        $moneyRole->givePermissionTo([
            'read-employes',
            'edit-employes-salaire'
        ]);

    }
}
