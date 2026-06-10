import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AppDrawerComponent } from './app-drawer.component';

describe('AppDrawerComponent', () => {
  let component: AppDrawerComponent;
  let fixture: ComponentFixture<AppDrawerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AppDrawerComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AppDrawerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
