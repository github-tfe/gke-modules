package main

import (
   "github.com/gruntwork-io/terratest/modules/terraform"
   "log"
   "testing"
   "github.com/stretchr/testify/assert"

)

func TestTerraformGkeCluster(t *testing.T) {

   options := &terraform.Options{
      TerraformDir: "../examples/",
   }

   defer terraform.Destroy(t, options)

   init, err := terraform.InitE(t, options)

   if err != nil {
      log.Println(err)
   }

   t.Log(init)

   plan, err := terraform.PlanE(t, options)

   if err != nil {
      log.Println(err)
   }

   t.Log(plan)

   apply, err := terraform.ApplyE(t, options)

   if err != nil {
      log.Println(err)
   }

   t.Log(apply)

   gke_cluster_name := terraform.Output(t, options, "gke_cluster_name")
   gke_cluster_version := terraform.Output(t, options, "gke_cluster_version")
   assert.Equal(t, "test-module1", gke_cluster_name)
   assert.Equal(t, "1.22.12-gke.2300", gke_cluster_version)
}
