$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("MY", "LocalMachine")
$store.Open("ReadOnly")

$certificates = $store.Certificates

foreach ($certificate in $certificates) {
    Write-Host "Subject: $($certificate.Subject)"
    Write-Host "Issuer: $($certificate.Issuer)"

    $privateKey = $certificate.PrivateKey
    if ($privateKey) {
        Write-Host "Key Algorithm: $($privateKey.KeyAlgorithm)"
        Write-Host "Key Size (bits): $($privateKey.KeySize)"
        Write-Host "Key Exportable: $($privateKey.Exportable)"
        if ($privateKey.Exportable) {
            $keyPath = "C:\Path\To\Save\Keys\$($certificate.Thumbprint).pfx"
            $privateKey | Export-Certificate -FilePath $keyPath -Password (Read-Host "Enter password for the exported key") -Exportable
            Write-Host "Exported key for $($certificate.Subject) to $keyPath"
        }
    } else {
        Write-Host "No private key found for the certificate."
    }

    Write-Host
}

$store.Close()
