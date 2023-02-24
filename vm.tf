resource "azurerm_windows_virtual_machine" "az-lab-vm" {
    name = "az-lab-win-vm"
    resource_group_name = azurerm_resource_group.Az-lap-rg.name
    location = azurerm_resource_group.Az-lap-rg.location
    admin_username = "useradm"
    admin_password = "Mayday*1245"
    size = "Standard_B2s"
    network_interface_ids = [azurerm_network_interface.az-lap-net-interface.id]

    os_disk {
      caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


resource "azurerm_managed_disk" "az-lab-managed-disk" {
    name = "az-lab-added-disk"
    resource_group_name = azurerm_resource_group.Az-lap-rg.name
    location = azurerm_resource_group.Az-lap-rg.location
    storage_account_type = "Standard_LRS"
    create_option = "Empty"
    disk_size_gb = "10"
    public_network_access_enabled = true
  
}

resource "azurerm_virtual_machine_data_disk_attachment" "az-lab-disk-attachment" {
  managed_disk_id = azurerm_managed_disk.az-lab-managed-disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.az-lab-vm.id
  lun = "10"
  caching = "ReadWrite"
}