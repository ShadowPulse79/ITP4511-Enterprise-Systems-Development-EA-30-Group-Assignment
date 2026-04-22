package com.leese.cchcsystem.model.entity;

import java.sql.Timestamp;

public class Clinic {
    private int id;
    private String name;
    private String location;
    private boolean walkInEnabled;
    private Timestamp createdAt;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public boolean isWalkInEnabled() { return walkInEnabled; }
    public void setWalkInEnabled(boolean walkInEnabled) { this.walkInEnabled = walkInEnabled; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
